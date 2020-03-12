class_name MessageSerializer

extends Node
#
var error_codes = TypeDefinitions.ErrorCodes
var message_names = TypeDefinitions.MessageNames
var message_templates = TypeDefinitions.message_templates()
#
var data := {}
var error : int = error_codes.OK
var type : int = message_names.NULL

func to_array() -> Array:
	if !message_templates.has(type):
		print_parsing_error(error_codes.MESSAGE_TYPE_NOT_FOUND, 'serialize', data)
		error = error_codes.MESSAGE_TYPE_NOT_FOUND
		return []
	var template = message_templates[type]
	
	var result = []
	result.resize(template.size() + 1)
	result[0] = type

	var keys = template.keys()
	for index in range(1, template.size()+1):
		var key = keys[index - 1]
		if key == 'timestamp':
			result[index] = OS.get_system_time_msecs()
		else:
			if data.has(key):
				result[index] = data[key]

	return result

func from_array(arr : Array, safe : bool = true) -> int:
	if !message_templates.has(arr[0]):
		error = error_codes.MESSAGE_TYPE_NOT_FOUND
		print_parsing_error(error, 'translate', arr)
		type = message_names.NULL
		data = {}
		return error
	var template = message_templates[arr[0]]
	var result = {}
	var keys = template.keys()
	if safe:
		for index in range(1, template.size()+1):
			var val = arr[index]
			var key = keys[index - 1]
			var type_validations = template[key]
			var val_is_valid = false
			for type in type_validations:
				val_is_valid = val_is_valid || (typeof(val) == type)
			if val_is_valid:
				result[key] = val
			else:
				error = error_codes.DATA_VALIDATION_FAILED
				print_parsing_error(error, 'translate', arr)
				return error
	else:
		for index in range(1, template.size()+1):
			result[keys[index - 1]] = arr[index]
	type = arr[0]
	data = result
	error = error_codes.OK
	return error

func print_parsing_error(error_code : int, method_name : String, data_to_print):
	print(
		'SerializationManager ', method_name,', ',
		'there was a error trying to parse a message, ',
		'error code: ', error_code,
		' received data: ', data_to_print
	)

func copy():
	var message = load(get_script().resource_path).new()
	message.data = data
	message.error = error
	message.type = type
	return message

func apply_to(dict):
	for key in dict:
		if data.has(key):
			dict[key] = data[key]
