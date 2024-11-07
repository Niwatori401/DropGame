extends Node

var should_fade_out = false;

func _ready():
	$CreditsScreen/DarkScreen.show();
	$CreditsScreen/DarkScreen.modulate.a = 1;

func _process(delta):
	$CreditsScreen/Background_1.rotation += delta * 0.1
	$CreditsScreen/Background_2.rotation -= delta * 0.2
	
	if should_fade_out:
		if $CreditsScreen/DarkScreen.modulate.a < 0:
			$CreditsScreen/DarkScreen.modulate.a = 0;
		
		$CreditsScreen/DarkScreen.modulate.a += delta * 1.5;
	else:
		$CreditsScreen/DarkScreen.modulate.a -= delta * 1.5;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
