extends Node

var should_fade_out = false;

var config = ConfigFile.new();

func _ready():
	$MainMenuSelectionScreen/DarkScreen.show();
	$MainMenuSelectionScreen/DarkScreen.modulate.a = 1;
	config.load("user://config.cfg");
	if !config.get_value("account", "useAccount"):
		$MainMenuSelectionScreen/MenuOptions/LeaderboardButton.hide();

func _process(delta):
	if should_fade_out:
		if $MainMenuSelectionScreen/DarkScreen.modulate.a < 0:
			$MainMenuSelectionScreen/DarkScreen.modulate.a = 0;
		
		$MainMenuSelectionScreen/DarkScreen.modulate.a += delta * 1.5;
	else:
		$MainMenuSelectionScreen/DarkScreen.modulate.a -= delta * 1.5;

func _on_exit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://main_root.tscn"))
	


func _on_options_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://options_menu.tscn"))


func _on_leaderboard_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://leaderboard_screen.tscn"))


func _on_credits_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://credits_menu.tscn"))


func _on_logout_pressed():
	config.erase_section_key("account", "useAccount");
	config.erase_section_key("account", "username");
	config.erase_section_key("account", "password");
	config.save("user://config.cfg");
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://user_entry.tscn"));
