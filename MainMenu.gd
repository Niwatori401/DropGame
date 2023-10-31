extends Node

var should_fade_out = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenuSelectionScreen/DarkScreen.show();
	$MainMenuSelectionScreen/DarkScreen.modulate.a = 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_fade_out:
		if $MainMenuSelectionScreen/DarkScreen.modulate.a < 0:
			$MainMenuSelectionScreen/DarkScreen.modulate.a = 0;
		
		$MainMenuSelectionScreen/DarkScreen.modulate.a += delta * 0.7;
	else:
		$MainMenuSelectionScreen/DarkScreen.modulate.a -= delta * 0.7;

func _on_exit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://main_root.tscn"))
	


func _on_options_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://options_menu.tscn"))


func _on_leaderboard_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://leaderboard_screen.tscn"))


func _on_credits_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://credits_menu.tscn"))
