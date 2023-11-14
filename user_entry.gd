extends Node

var base_url = "http://localhost:8080"
var should_fade_out = false;
var config = ConfigFile.new()


func _ready():
	$Foreground.show();
	$Foreground.modulate.a = 0;

	if config.load("user://config.cfg") != OK or !config.has_section("account"):
		return;

	$Username/UsernameField.set_text(config.get_value("account", "username").strip_edges(true, true));
	$Password/PasswordField.set_text(config.get_value("account", "password").strip_edges(true, true));
	_on_submit_button_pressed()
	
func _process(delta):
	if should_fade_out:
		$Foreground.modulate.a += delta;

func _on_submit_button_pressed():
	$HTTPSubmit.request_completed.connect(on_submit_request_complete);
	var user_name = $Username/UsernameField.get_text().strip_edges(true, true);
	var password = $Password/PasswordField.get_text().strip_edges(true, true);
	var url = "%s/user/createUser" % [base_url];
	var hashed_pass = password.hash();
	var json = '{"namePassHash": {"userName": "%s", "passHash": "%s"}}' % [user_name, hashed_pass];
	var headers = ["Content-Type: application/json"]
	
	$HTTPSubmit.request(url, headers, HTTPClient.METHOD_POST, json)


func _on_skip_button_pressed():
	config.set_value("account", "useAccount", false);
	config.set_value("account", "username", "NONE")
	config.set_value("account", "password", "NONE")
	should_fade_out = true;
	get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
	config.save("user://config.cfg");

func on_submit_request_complete(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8());
	var nameOk = json["nameOk"];
	var passOk = json["passOk"];
	if !nameOk:
		$Username/ErrorText.set_text("[color=red]Bad user name: %s[/color]" % [json["nameReason"]])

	if !passOk:
		$Password/ErrorText.set_text("[color=red]Bad password: %s[/color]" % [json["passReason"]])

	if passOk and nameOk and response_code == 200:
		config.set_value("account", "useAccount", true);
		config.set_value("account", "username", $Username/UsernameField.get_text().strip_edges(true, true));
		config.set_value("account", "password", $Password/PasswordField.get_text().strip_edges(true, true));
		config.save("user://config.cfg");
		should_fade_out = true;
		get_tree().create_timer(1.5).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
