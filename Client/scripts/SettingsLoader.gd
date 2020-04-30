class_name SettingsLoader

extends Node

var settings
var error
const settings_file_path = "res://connection_settings.ini"

func _init():
	load_config()
	
func load_config():
	var config_file = ConfigFile.new()
	var err = config_file.load(settings_file_path)
	
	if err != OK:
		error = err
		print('Settings Loader err => ', err)
		return
	settings = config_file
