extends Spatial

var Player = preload("res://shared/props/player.tscn")
var players = {}

func _ready():
	pass

func add_player(player_data):
	# print('WorldSimulation add_player(player_data) ', player_data)
	players[player_data.id] = player_data
	var player = players[player_data.id]
	player['instance'] = Player.instance()
	player.instance.id = player_data.id
	player.instance.translation = player.position
	add_child(player.instance)

func add_local_player(player_data):
	add_player(player_data)
	var player = players[player_data.id]
	player.instance.is_local = true
	return player

func update_player(id, new_data):
	# print('WorldSimulation update_player(id, new_data) (', id,', ', new_data, ')')
	var player = players[id]
	var player_instance = player.instance
	player.position = new_data.position
	player.movement_vector = new_data.movement_vector
	player.y_rotation = new_data.y_rotation
	if player.position:
		player_instance.translation = player.position
	player_instance.movement_vector = player.movement_vector
	if !player_instance.is_local && player.y_rotation:
		player_instance.rotation.y = player.y_rotation


func remove_player(player_id):
	# print('WorldSimulation remove_player(player_id) (', player_id ,')')
	if players.has(player_id):
		var player = players[player_id]
		players.erase(player_id)
		player.instance.queue_free()
	else:
		print('trying to remove a nonexistent player')
