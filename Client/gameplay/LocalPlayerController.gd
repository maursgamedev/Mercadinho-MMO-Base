extends Node

#
var local_player_instance = null setget set_player
var player_camera = null
#
var speed = 600
var last_y_rotation = null
var current_y_rotation = null
var direction_vector = Vector2() setget set_direction_vector
var movement_vector = Vector3() setget set_movement_vector
var sync_timer = Timer.new()

func _ready():
	var errors = []
	# sync_timer.wait_time = 0.1
	# errors.append(sync_timer.connect('timeout', self, 'update_data_on_server'))
	# sync_timer.autostart = true
	# add_child(sync_timer)
	# sync_timer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	handle_local_movement()
	if event is InputEventMouseMotion && player_camera && local_player_instance:
		var camera_rotation_x = clamp(
			player_camera.rotation.x - (event.relative.y / 100.0), 
			deg2rad(-30.0),
			deg2rad(15.0)
		)
		player_camera.rotation.x = camera_rotation_x
		set_y_rotation(local_player_instance.rotation.y - event.relative.x / 100)

func set_player(player_instance):
	local_player_instance = player_instance
	player_camera = local_player_instance.get_node('PlayerCamera')
	player_camera.current = true

func handle_local_movement():
	var new_direction_vector = Vector2()
	if Input.is_action_pressed('player_up'):
		new_direction_vector.y -= 1
	if Input.is_action_pressed('player_down'):
		new_direction_vector.y += 1
	if Input.is_action_pressed('player_left'):
		new_direction_vector.x -= 1
	if Input.is_action_pressed('player_right'):
		new_direction_vector.x += 1
	if !local_player_instance:
		return
	if new_direction_vector != direction_vector || last_y_rotation != current_y_rotation:
		last_y_rotation = current_y_rotation
		self.direction_vector = new_direction_vector
		self.movement_vector = Vector3(
			direction_vector.x, 0.0, direction_vector.y
		).rotated(Vector3(0.0,1.0,0.0), local_player_instance.rotation.y) * speed

func update_data_on_server():
	GameplaySignals.emit_signal('broadcast_y_rotation', current_y_rotation)
	GameplaySignals.emit_signal('broadcast_movement_vector', movement_vector)

func set_y_rotation(new_y_rotation):
	current_y_rotation = new_y_rotation
	if local_player_instance:
		local_player_instance.rotation.y = current_y_rotation
	GameplaySignals.emit_signal('broadcast_y_rotation', new_y_rotation)

func set_movement_vector(new_movement_vector):
	movement_vector = new_movement_vector
	GameplaySignals.emit_signal('broadcast_movement_vector', movement_vector)

func set_direction_vector(new_direction_vector):
	direction_vector = new_direction_vector
