extends Node2D

var should_fade_out = false;

func _ready():
	$DarkScreen.show();
	$DarkScreen.modulate.a = 1;

func _process(delta):
	if should_fade_out:
		if $DarkScreen.modulate.a < 0:
			$DarkScreen.modulate.a = 0;
		
		$DarkScreen.modulate.a += delta * 0.7;
	else:
		$DarkScreen.modulate.a -= delta * 0.7;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
