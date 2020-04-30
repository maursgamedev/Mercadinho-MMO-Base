extends VBoxContainer


signal submit(data)
signal go_back()

# Buttons
onready var go_back_button = $HBoxContainer/GoBackButton
onready var confirm_button = $HBoxContainer/ConfirmButton

# Inputs
onready var email_input = $Email
onready var username_input = $Username
onready var password_input = $PasswordGroup/VBoxContainer/Password
onready var password_confirmation_input = $PasswordGroup/VBoxContainer2/PasswordConfirmation
onready var tos_checkbox_input = $HBoxContainer2/TOSCheck

#Error
onready var error_label = $ErrorLabel

func _ready():
	go_back_button.connect('pressed', self, 'emit_signal', ['go_back'])
	confirm_button.connect('pressed', self, 'submit')

func get_data():
	return {
		username = username_input.text,
		email = email_input.text,
		password = password_input.text,
		password_confirmation = password_confirmation_input.text,
		tos_checked = tos_checkbox_input.pressed
	}
	
func show_error(error):
	error_label.text = String(error)

func submit():
	emit_signal('submit', get_data())
