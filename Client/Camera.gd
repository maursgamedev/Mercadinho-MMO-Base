extends Camera

var shared_commons = SharedCommons.new()
var walkable_layer = shared_commons.mask_name_to_bit.walkable_terrain
var mouse_down := false
var mouse_position := Vector2()

func _ready():
	print()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				mouse_position = event.position
				mouse_down = true
				var space_state = get_world().direct_space_state
				if mouse_down:
					var mouse = mouse_position
					var from = project_ray_origin(mouse)
					var to = project_ray_normal(mouse) * 1000
					var ray = space_state.intersect_ray(from, to, [self], walkable_layer, true, true)
					print('ray ', ray )
			else: 
				mouse_down = false

#func _physics_process(_delta):

