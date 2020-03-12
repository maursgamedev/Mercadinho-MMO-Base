class_name TypeDefinitions

enum MessageNames {
	NULL = -1,
	# Server Messages
	SV_NEW_PLAYER_CONNECTION = 10,
	SV_PLAYER_DISCONNECTED,
	SV_PLAYER_UPDATE_ALL_DATA,
	SV_UPDATE_Y_ROTATION,
	
	# Individual Server Messages
	SV_OWN_PLAYER_DATA = 1000,
	SV_OWN_UPDATE_MOVEMENT_VECTOR,

	# Client Messages
	CL_UPDATE_MOVEMENT_VECTOR = 2000,
	CL_UPDATE_Y_ROTATION,
}

enum ErrorCodes {
	OK,
	MESSAGE_TYPE_NOT_FOUND,
	DATA_VALIDATION_FAILED
}

# see variable types here
# http://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-variant-type

static func message_templates():
	return {
		# Server Messages
		MessageNames.SV_NEW_PLAYER_CONNECTION: {
			timestamp = [TYPE_INT],
			id = [TYPE_INT],
			position = [TYPE_VECTOR3],
			movement_vector = [TYPE_VECTOR3],
			y_rotation = [TYPE_INT, TYPE_REAL]
		},
		MessageNames.SV_PLAYER_DISCONNECTED: {
			timestamp = [TYPE_INT],
			id = [TYPE_INT]
		},
		MessageNames.SV_PLAYER_UPDATE_ALL_DATA: {
			timestamp = [TYPE_INT],
			id = [TYPE_INT],
			position = [TYPE_VECTOR3],
			movement_vector = [TYPE_VECTOR3],
			y_rotation = [TYPE_INT, TYPE_REAL] 
		},
		MessageNames.SV_UPDATE_Y_ROTATION: {
			timestamp = [TYPE_INT],
			id = [TYPE_INT],
			position = [TYPE_VECTOR3],
			y_rotation = [TYPE_INT, TYPE_REAL],
		},

		# Individual Server Messages
		MessageNames.SV_OWN_PLAYER_DATA: {
			timestamp = [TYPE_INT],
			id = [TYPE_INT],
			position = [TYPE_VECTOR3],
			movement_vector = [TYPE_VECTOR3],
			y_rotation = [TYPE_INT, TYPE_REAL]
		},

		# Client Messages
		MessageNames.CL_UPDATE_MOVEMENT_VECTOR: {
			timestamp = [TYPE_INT],
			movement_vector = [TYPE_VECTOR3]
		},
		MessageNames.CL_UPDATE_Y_ROTATION: {
			timestamp = [TYPE_INT],
			y_rotation = [TYPE_INT, TYPE_REAL]
		}
	}
