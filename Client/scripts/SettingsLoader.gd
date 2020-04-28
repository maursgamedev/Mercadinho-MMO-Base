class_name SettingsLoader

extends Node

var settings
const settings_file_path = "res://connection_settings.ini"

func _init():
	print('SettingsLoader initialize')
	load_config()
	
func load_config():
	var config_file = ConfigFile.new()
	var err = config_file.load(settings_file_path)
	
	if err != OK:
		print(err)
		return err
	print(config_file)	
	settings = config_file
