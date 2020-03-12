class_name SharedCommons

extends Node

var mask_name_to_bit = {}

func _init():
	init_mask_names()

func init_mask_names():
	for i in range(1, 21):
		print('i ', i)
		var layer_name = ProjectSettings.get_setting(str("layer_names/3d_physics/layer_", i))
		print('layer_name', layer_name)

		if not layer_name: 
			layer_name = str("Layer ", i)

		mask_name_to_bit[layer_name] = i
