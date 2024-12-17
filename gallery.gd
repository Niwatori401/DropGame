extends Control


func _ready() -> void:
	$Fader.lighten(2);
	$CutscenePlayer.finished.connect(func(): $CutscenePlayer.visible = false);
	$CutscenePlayer.visible = false;
	$DisplayItem.visible = false;
	update_button_graphics_by_unlock();

func update_button_graphics_by_unlock():
	#var cutscenes_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CUTSCENES);
	#var sketches_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_SKETCHES);
	#var concept_locked : bool = not Inventory.is_trinket_unlocked(Globals.TRINKET_GALLERY_CONCEPT);
	var cutscenes_locked = false;
	var sketches_locked : bool = false;
	var concept_locked : bool = false;
	
	# Cutscene Group
	$GalleryGrid/GalleryItem_OpeningCutscene.disabled = cutscenes_locked;
	
	# Sketch Group
	$GalleryGrid/GalleryItem_Sketch_1.disabled = sketches_locked;
	
	# Concept Group
	$GalleryGrid/GalleryItem_concept_1.disabled = concept_locked;

	
	# Special
	var finished_game : bool = true; #Inventory.get_save().get_value(Globals.SAVE_CATEGORY_PROGRESS, Globals.SAVE_KEY_FINISHED_GAME, false);
	$GalleryGrid/GalleryItem_FinaleImage.disabled = not finished_game;


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		$CutscenePlayer.visible = false;
		$CutscenePlayer.stop();
		$DisplayItem.visible = false;


func _on_gallery_item_sketch_1_button_down() -> void:
	$DisplayItem.visible = true;
	#$DisplayItem.texture = preload("res://asset/gallery/sketches/client_sizes.png");

func _on_gallery_item_concept_1_button_down() -> void:
	$DisplayItem.visible = true;
	#$DisplayItem.texture = preload("res://asset/gallery/concept/characters.png");

func _on_gallery_item_finale_image_button_down() -> void:
	$DisplayItem.visible = true;
	#$DisplayItem.texture = preload("res://asset/cutscene/end_photo.png");


func _on_back_button_button_down() -> void:
	$Fader.darken(2);
	get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))

