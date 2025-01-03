extends Node

var should_fade_out = false;


var title_growing = true;
var MINIMUM_TITLE_SIZE = 0.98;
var MAXIMUM_TITLE_SIZE = 1.02;
var current_title_size = 1;
var TITLE_GROWTH_RATE = 0.02;


func _ready():

	$BGM.play();

	$MainMenuSelectionScreen/DarkScreen.show();
	$MainMenuSelectionScreen/DarkScreen.modulate.a = 1;
	if !Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_USEACCOUNT):
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
		
		$BGM.volume_db -= delta * 20;
		$MainMenuSelectionScreen/DarkScreen.modulate.a += delta * 1.5;
	else:
		$MainMenuSelectionScreen/DarkScreen.modulate.a -= delta * 1.5;

func _on_exit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): 
		get_tree().change_scene_to_file("res://scene/level/main_root.tscn"); 
		$BGM.stop();
		)
	


func _on_options_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/options_menu.tscn"))


func _on_leaderboard_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/leaderboard_screen.tscn"))


func _on_credits_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/credits_menu.tscn"))


func _on_logout_pressed():
	Config.get_config().erase_section_key(Config.SECTION_ACCOUNT, Config.KEY_USEACCOUNT);
	Config.get_config().erase_section_key(Config.SECTION_ACCOUNT, Config.KEY_USERNAME);
	Config.get_config().erase_section_key(Config.SECTION_ACCOUNT, Config.KEY_PASSWORD);
	Config.commit_changes();
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/user_entry.tscn"));


func _on_gallery_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/gallery.tscn"))
