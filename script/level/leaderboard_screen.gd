extends Control

var should_fade_out = false;


func _ready():
	$DarkScreen.show();
	$DarkScreen.modulate.a = 1;
func _process(delta):
	$Background_1.rotation += delta * 0.1
	$Background_2.rotation -= delta * 0.2
	

	if should_fade_out:
		if $DarkScreen.modulate.a < 0:
			$DarkScreen.modulate.a = 0;
		
		$DarkScreen.modulate.a += delta * 1.5;
	else:
		$DarkScreen.modulate.a -= delta * 1.5;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/main_menu.tscn"))

