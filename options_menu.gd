extends Node

var should_fade_out = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$OptionsScreen/DarkScreen.show();
	$OptionsScreen/DarkScreen.modulate.a = 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if should_fade_out:
		if $OptionsScreen/DarkScreen.modulate.a < 0:
			$OptionsScreen/DarkScreen.modulate.a = 0;
		
		$OptionsScreen/DarkScreen.modulate.a += delta * 0.7;
	else:
		$OptionsScreen/DarkScreen.modulate.a -= delta * 0.7;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
	
