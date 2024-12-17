extends TextureProgressBar
const INITIAL_FACE_POSITION : Vector2 = Vector2(644, 260);
const START_OF_METER_POSITION : Vector2 = Vector2(553, 260);
const END_OF_METER_POSITION : Vector2 = Vector2(150, 260);
const FINAL_FACE_POSITION : Vector2 = Vector2(36, 260);

const FACE_GRAPHICS = [
	preload("res://art/progress_meter/char_face_1g.png"),
	preload("res://art/progress_meter/char_face_2g.png"),
	preload("res://art/progress_meter/char_face_3g.png"),
	preload("res://art/progress_meter/char_face_4g.png"),
	preload("res://art/progress_meter/char_face_5g.png"),
	preload("res://art/progress_meter/char_face_6g.png"),
	preload("res://art/progress_meter/char_face_7g.png"),
	preload("res://art/progress_meter/char_face_8g.png"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.stage_changed.connect(change_head_for_stage);
	change_head_for_stage(1);


# uses percent as decimal
func set_finished_percent(percent : float):
	if percent <= 0:
		$Face.position
	elif percent >= 1:
		$Face.position = FINAL_FACE_POSITION;
	else:
		$Face.position = percent * (END_OF_METER_POSITION - START_OF_METER_POSITION)

func change_head_for_stage(stage_number : int):
	if stage_number < 1 or stage_number > len(FACE_GRAPHICS):
		printerr("Bad stage number in score progress indicator: %s" % [stage_number]);
		return;
	
	$Face.texture = FACE_GRAPHICS[stage_number - 1];


