extends Node

var should_fade_out = false;


func _ready():
	$OptionsScreen/DarkScreen.show();
	$OptionsScreen/DarkScreen.modulate.a = 1;


func _process(delta):
	if should_fade_out:
		if $OptionsScreen/DarkScreen.modulate.a < 0:
			$OptionsScreen/DarkScreen.modulate.a = 0;
		
		$OptionsScreen/DarkScreen.modulate.a += delta * 1.5;
	else:
		$OptionsScreen/DarkScreen.modulate.a -= delta * 1.5;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
	
