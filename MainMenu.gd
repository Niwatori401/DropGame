extends Node

var should_fade_out = false;


var title_growing = true;
var MINIMUM_TITLE_SIZE = 0.98;
var MAXIMUM_TITLE_SIZE = 1.02;
var current_title_size = 1;
var TITLE_GROWTH_RATE = 0.02;


var config = ConfigFile.new();


func _ready():
	if !get_node("/root/Globals").started_main_menu_music:
		get_node("/root/Globals").started_main_menu_music = true;
		get_node("/root/Globals/BGM").play();
	if !get_node("/root/Globals").one_time_music_volume_adjusted:
		get_node("/root/Globals").one_time_music_volume_adjusted = true;
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -12);
		
	$MainMenuSelectionScreen/DarkScreen.show();
	$MainMenuSelectionScreen/DarkScreen.modulate.a = 1;
	config.load("user://config.cfg");
	if !config.get_value("account", "useAccount"):
		$MainMenuSelectionScreen/MenuOptions/LeaderboardButton.hide();

func _process(delta):
	$MainMenuSelectionScreen/Background_1.rotation += delta * 0.1
	$MainMenuSelectionScreen/Background_2.rotation -= delta * 0.2
	
	if (title_growing):
		current_title_size += TITLE_GROWTH_RATE * delta;
		if (current_title_size >= MAXIMUM_TITLE_SIZE):
			title_growing = false;
	else:
		current_title_size -= TITLE_GROWTH_RATE * delta;
		if (current_title_size <= MINIMUM_TITLE_SIZE):
			title_growing = true;
	
	$MainMenuSelectionScreen/GameTitle.scale = Vector2(current_title_size, current_title_size)
	
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
	get_tree().create_timer(1).timeout.connect(func(): 
		get_tree().change_scene_to_file("res://main_root.tscn"); 
		get_node("/root/Globals/BGM").stop();
		get_node("/root/Globals").started_main_menu_music = false;
		)
	


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
