extends KinematicBody

var movement_vector = Vector3()
var is_local = false
var id = null

func _process(delta):
	var _collision = move_and_slide(movement_vector * delta)

func sync_data():
	return {
		id = int(id),
		position = Vector3(translation),
		movement_vector = Vector3(movement_vector),
		y_rotation = float(rotation.y)
	}
