extends Control


enum LoginPageStates {
	BUSY,
	LOGIN_FORM,
	REGISTRATION_FORM
}

onready var busy_message = $Panel/MarginContainer/BusyMessage
onready var login_form = $Panel/MarginContainer/LoginForm
onready var registration_form = $Panel/MarginContainer/RegistrationForm

var email_validator_regex = RegEx.new()

var current_busy_message = 'Connecting...'

func _ready():
	email_validator_regex.compile("^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$")
	registration_form.connect('submit', self, 'submit_registration')
	registration_form.connect('go_back', self, 'render_state', [LoginPageStates.LOGIN_FORM])
	login_form.connect('submit', self, 'submit_login')
	login_form.connect('registration_request', self, 'render_state', [LoginPageStates.REGISTRATION_FORM])
	$HTTPRequest.connect('request_completed', self, 'request_finished')
	
func render_state(state):
	print('render_state state ', state)
	render_busy(state)
	render_login_form(state)
	render_registration_form(state)

func render_busy(state):
	busy_message.visible = state == LoginPageStates.BUSY
	busy_message.text = current_busy_message

func render_login_form(state):	
	login_form.visible = state == LoginPageStates.LOGIN_FORM

func render_registration_form(state):
	registration_form.visible = state == LoginPageStates.REGISTRATION_FORM

func submit_login(data):
	print('submit_login ', data)

func validate_registration_data(data):
	var errors = []
	print('validate_registration_data data', data)
	if data.username.length() < 1:
		errors.append('Please select a username')
	if data.email.length() < 1:
		errors.append('Please inform your email')
	if !email_validator_regex.search(data.email):
		errors.append('Please insert a valid email')
	if data.password != data.password_confirmation:
		errors.append("The password and password confirmation don't match")
	if data.password.length() < 6:
		errors.append('The password needs to be at least 6 characters long.')
	if !data.tos_checked:
		errors.append('Please make sure to read, and agree with the Terms of Service')
	print('validate_registration_data errors', errors)
	return errors

func submit_registration(data):
	var errors = validate_registration_data(data)
	if errors.size() > 0:
		registration_form.show_error(errors[0])
		return
	# Clears the error message
	registration_form.show_error('')
	render_state(LoginPageStates.BUSY)
	var route = "%s/players/users" % Globals.settings.settings.get_value('auth_server','address', 'http://localhost:3031')
	var headers = ["Content-Type: application/json"]
	var err = $HTTPRequest.request(
		route, headers,
		true, 
		HTTPClient.METHOD_POST,
		JSON.print(data)
	)

func request_finished(result, response_code, headers, body):
	var response_data = null
	if response_code >= 200:
		var parsed_json = JSON.parse(body.get_string_from_utf8())
		if parsed_json.error != OK:
			print('There was a error trying to parse the response from the auth server')
			print('data received: ', body.get_string_from_utf8())
			registration_form.show_error('There was a error trying to parse a response.')
			render_state(LoginPageStates.REGISTRATION_FORM)
			return
		response_data = parsed_json.result
	if response_code >= 400:
		print('There was a error during the user registration:')
		print('data received: ', response_data)
		registration_form.show_error(response_data.error)
		render_state(LoginPageStates.REGISTRATION_FORM)
		return
	if response_code == 200:
		print('User was registered successfully')
		print('data received: ', response_data)

