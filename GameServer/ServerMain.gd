extends Node

const PORT = 32784
#
var error_codes = TypeDefinitions.ErrorCodes
var message_names = TypeDefinitions.MessageNames
#
var server = WebSocketServer.new()
var connections = {}
onready var world_simulation = $WorldSimulation

func _ready():
	server.connect("client_connected", self, "_connected")
	server.connect("client_disconnected", self, "_disconnected")
	server.connect("client_close_request", self, "_close_request")
	server.connect("data_received", self, "_on_data")
	var err = server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)

func _connected(id, proto):
	connections[id] = {id = id, proto = proto, position = Vector3(), movement_vector = Vector3(), y_rotation = 0, updated = false}
	var connection = connections[id]
	world_simulation.add_player(connections[id])
	var message = MessageSerializer.new()
	message.data = connection
	message.type = message_names.SV_NEW_PLAYER_CONNECTION
	var to_submit = message.to_array()
	if message.error == error_codes.OK:
		broadcast_all(to_submit, id)
	send_initialization_data(id)
	print("Client %d connected with protocol: %s" % [id, proto])

func send_initialization_data(id):
	# Sends other players data so the player can see them.
	var message = MessageSerializer.new()
	message.type = message_names.SV_NEW_PLAYER_CONNECTION
	for connection_id in connections:
		if connection_id != id:
			var connection = connections[connection_id]
			message.data = connection
			server.get_peer(id).put_var(message.to_array())
	# Sends the own player data so it can be initialized.
	var player_response = MessageSerializer.new()
	player_response.type = message_names.SV_OWN_PLAYER_DATA
	player_response.data = connections[id]
	server.get_peer(id).put_var(player_response.to_array())

func _close_request(id, _code, _reason):
	connections.erase(id)
	world_simulation.remove_player(id)

func _disconnected(id, was_clean = false):
	connections.erase(id)
	world_simulation.remove_player(id)
	broadcast_disconnection(id)
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func broadcast_disconnection(id):
	var message = MessageSerializer.new()
	message.data = {'id': id}
	message.type = message_names.SV_PLAYER_DISCONNECTED
	var to_submit = message.to_array()
	if message.error == error_codes.OK:
		broadcast_all(to_submit,id)

func broadcast_all(message, except = null):
	for id in connections:
		if id != except:
			server.get_peer(id).put_var(message)

func _on_data(id):
	var connection = connections[id]
	var raw_message = server.get_peer(id).get_var()
	if raw_message is Array:
		var message = MessageSerializer.new()
		message.from_array(raw_message)
		match message.type:
			message_names.CL_UPDATE_MOVEMENT_VECTOR:
				message.apply_to(connection)
				connection.updated = true
			message_names.CL_UPDATE_Y_ROTATION:
				message.apply_to(connection)
				connection.updated = true
		world_simulation.update_player(id, connection)

func _process(_delta):
	server.poll()
	for connection_id in connections:
		var connection = connections[connection_id]
		if connection.updated:
			connection.updated = false
			var player = world_simulation.players[connection_id]
			var message = MessageSerializer.new()
			message.type = message_names.SV_PLAYER_UPDATE_ALL_DATA
			message.data = player.instance.sync_data()
			broadcast_all(message.to_array(), connection.id)
