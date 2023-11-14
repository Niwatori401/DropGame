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
	


func _on_music_slider_value_changed(value):
	if (value == 0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true);
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false);
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), lerp(-30, 15, value / 100));


func _on_sfx_slider_value_changed(value):
	if (value == 0):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), true);
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("SFX"), false);
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-30, 15, value / 100));


func _on_sfx_slider_drag_ended(value_changed):
	$OptionsScreen/SFXVolumeSlider/SFXTestSound.play()
