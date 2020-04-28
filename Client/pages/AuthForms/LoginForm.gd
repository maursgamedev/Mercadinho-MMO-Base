extends VBoxContainer

onready var username_input = $UsernameInput
onready var password_input = $PasswordInput
#
onready var registration_button = $RegistrationButton
#
onready var error_label = $ErrorLabel
# Buttons
onready var close_button = $HBoxContainer/CloseButton
onready var confirm_button = $HBoxContainer/ConfirmButton
#
onready var remember_username_checkbox = $RememberUsernameCheckbox
#
signal submit(data)
signal registration_request()
signal close_request()
signal remember_username_request(remember)

func _ready():
	confirm_button.connect('pressed', self, 'confirm')
	registration_button.connect('pressed', self, 'emit_signal', ['registration_request'])
	close_button.connect('pressed', self, 'emit_signal', ['close_request'])
	remember_username_checkbox.connect('toggled', self, 'on_remember_username_toggle')

func on_remember_username_toggle(checked):
	emit_signal('remember_username_request', checked)

func show_error(error):
	error_label.text = error

func clear_error():
	error_label.text = ''

func confirm():
	var data = {
		username = username_input.text,
		password = password_input.text
	}
	emit_signal('submit', data)
