extends Node

var should_fade_out = false;


func _ready():
	$Foreground.show();
	$Foreground.modulate.a = 0;

	if !Config.get_config().has_section(Config.SECTION_ACCOUNT):
		return;

	$Username/UsernameField.set_text(Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_USERNAME).strip_edges(true, true));
	$Password/PasswordField.set_text(Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_PASSWORD).strip_edges(true, true));
	_on_submit_button_pressed()
	
func _process(delta):
	if should_fade_out:
		$Foreground.modulate.a += delta;

func _on_submit_button_pressed():
	$HTTPSubmit.request_completed.connect(on_submit_request_complete);
	var user_name = $Username/UsernameField.get_text().strip_edges(true, true);
	var password = $Password/PasswordField.get_text().strip_edges(true, true);
	var base_url = Config.get_config().get_value(Config.SECTION_APPLICATION, Config.KEY_BASEURL);
	var url = "%s/user/createUser" % [base_url];
	var hashed_pass = password.hash();
	var json = '{"namePassHash": {"userName": "%s", "passHash": "%s"}}' % [user_name, hashed_pass];
	var headers = ["Content-Type: application/json"]
	
	$HTTPSubmit.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_skip_button_pressed():
	Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_USEACCOUNT, false);
	Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_USERNAME, "NONE")
	Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_PASSWORD, "NONE")
	should_fade_out = true;
	get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/main_menu.tscn"))
	Config.commit_changes();

func on_submit_request_complete(_result, response_code, _headers, body):
	if (response_code != 200):
		return;
		
	var json = JSON.parse_string(body.get_string_from_utf8());
	var nameOk = json["nameOk"];
	var passOk = json["passOk"];
	if !nameOk:
		$Username/ErrorText.set_text("[color=red]Bad user name: %s[/color]" % [json["nameReason"]])

	if !passOk:
		$Password/ErrorText.set_text("[color=red]Bad password: %s[/color]" % [json["passReason"]])

	if passOk and nameOk and response_code == 200:
		Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_USEACCOUNT, true);
		Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_USERNAME, $Username/UsernameField.get_text().strip_edges(true, true));
		Config.get_config().set_value(Config.SECTION_ACCOUNT, Config.KEY_PASSWORD, $Password/PasswordField.get_text().strip_edges(true, true));
		Config.commit_changes();
		should_fade_out = true;
		get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/main_menu.tscn"))
