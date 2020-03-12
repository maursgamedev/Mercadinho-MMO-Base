extends Node

#
var error_codes = TypeDefinitions.ErrorCodes
var message_names = TypeDefinitions.MessageNames
#

var websocket_url = "ws://localhost:32784"

var is_connected = false
var websocket = WebSocketClient.new()
onready var world_simulation = $WorldSimulation

func _ready():
	var errors = []
	errors.append(websocket.connect("connection_closed", self, "_closed"))
	errors.append(websocket.connect("connection_error", self, "_closed"))
	errors.append(websocket.connect("connection_established", self, "_connected"))
	errors.append(websocket.connect("data_received", self, "_on_data"))
	errors.append(GameplaySignals.connect("broadcast_movement_vector", self, 'send_movement_data'))
	errors.append(GameplaySignals.connect("broadcast_y_rotation", self, 'send_y_rotation'))

	var err = websocket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else: 
		print("Successfully connected to the server")
	for error in errors:
		if error != OK:
			print('ClientMain _ready(): There was  error trying to connect to a signal, error code: ', error)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)
	is_connected = false

func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	is_connected = true
	websocket.get_peer(1).put_var({teste= 'exemplo'})

func _on_data():
	var raw_message = websocket.get_peer(1).get_var()
	if raw_message is Array:
		var message = MessageSerializer.new()
		message.from_array(raw_message, false)
		if message.error != error_codes.OK:
			return
		match message.type:
			message_names.SV_NEW_PLAYER_CONNECTION:
				world_simulation.add_player(message.data)
			message_names.SV_OWN_PLAYER_DATA:
				var player = world_simulation.add_local_player(message.data)
				$LocalPlayerController.local_player_instance = player.instance
			message_names.SV_PLAYER_DISCONNECTED:
				world_simulation.remove_player(message.data.id)
			message_names.SV_PLAYER_UPDATE_ALL_DATA:
				print('ClientMain message.data', message.data)
				var player = world_simulation.players[message.data.id]
				message.apply_to(player)
				world_simulation.update_player(message.data.id, player)
			message_names.SV_UPDATE_Y_ROTATION:
				var player = world_simulation.players[message.data.id]
				message.apply_to(player)
				world_simulation.update_player(message.data.id, player)

func _process(_delta):
	websocket.poll()

func send_movement_data(movement_vector):
	if is_connected:
		print('ClientMain send_movement_data')
		var response = MessageSerializer.new()
		response.type = message_names.CL_UPDATE_MOVEMENT_VECTOR
		response.data = {'movement_vector': movement_vector}
		var to_send = response.to_array()
		if response.error != error_codes.OK:
			return
		websocket.get_peer(1).put_var(to_send)

func send_y_rotation(y_rotation):
	if is_connected:
		print('ClientMain send_y_rotation')
		var response = MessageSerializer.new()
		response.type = message_names.CL_UPDATE_Y_ROTATION
		response.data = {'y_rotation': y_rotation}
		var to_send = response.to_array()
		if response.error != error_codes.OK:
			return
		websocket.get_peer(1).put_var(to_send)
