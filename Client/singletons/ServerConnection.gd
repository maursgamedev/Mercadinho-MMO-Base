extends Node

var websocket = WebSocketClient.new()
var settings_loader = SettingsLoader.new()




func websocket_url():
	if _websocket_url:
		return _websocket_url
	if settings_loader.settings:
		print(settings_loader.settings.get_value('server', 'address'))
		_websocket_url = (
			"ws://%s:%s" % [
				settings_loader.settings.get_value('server', 'address'),
				settings_loader.settings.get_value('server', 'port')
			]
		)
	return _websocket_url