extends Node

var should_fade_out = false;

var title_growing = true;
var MINIMUM_TITLE_SIZE = 0.98;
var MAXIMUM_TITLE_SIZE = 1.02;
var current_title_size = 1;
var TITLE_GROWTH_RATE = 0.02;


func _ready():
	$OptionsScreen/DarkScreen.show();
	$OptionsScreen/DarkScreen.modulate.a = 1;
	$BGM.play();

func _process(delta):
	$OptionsScreen/Background_1.rotation += delta * 0.1
	$OptionsScreen/Background_2.rotation -= delta * 0.2
	
	if (title_growing):
		current_title_size += TITLE_GROWTH_RATE * delta;
		if (current_title_size >= MAXIMUM_TITLE_SIZE):
			title_growing = false;
	else:
		current_title_size -= TITLE_GROWTH_RATE * delta;
		if (current_title_size <= MINIMUM_TITLE_SIZE):
			title_growing = true;
	
	$OptionsScreen/OptionsTitle.scale = Vector2(current_title_size, current_title_size)
	
	if should_fade_out:
		if $OptionsScreen/DarkScreen.modulate.a < 0:
			$OptionsScreen/DarkScreen.modulate.a = 0;
		$BGM.volume_db -= 20 * delta;
		
		$OptionsScreen/DarkScreen.modulate.a += delta * 1.5;
	else:
		$OptionsScreen/DarkScreen.modulate.a -= delta * 1.5;

func _on_back_button_pressed():
	should_fade_out = true;
	get_tree().create_timer(1).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/main_menu.tscn"))
	


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


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		get_tree().get_root().set_mode(Window.MODE_FULLSCREEN);
	else:
		get_tree().get_root().set_mode(Window.MODE_WINDOWED);
