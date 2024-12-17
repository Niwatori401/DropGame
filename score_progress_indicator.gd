extends TextureProgressBar
const INITIAL_FACE_POSITION : Vector2 = Vector2(450, 160);
const START_OF_METER_POSITION : Vector2 = Vector2(450, 160);
const END_OF_METER_POSITION : Vector2 = Vector2(50, 160);
const FINAL_FACE_POSITION : Vector2 = Vector2(50, 160);

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

var score : float = 0;
var max_score_for_graphics : float = 5000;

var cur_secs_between_rotation : float = 0;
var total_secs_between_rotation : float = 0.5;
var degrees_to_rotate : float = 10;
var should_rotate_left : bool = true;
var should_start_rotate_counter : bool = false;

func _ready():
	SignalBus.stage_changed.connect(change_head_for_stage);
	SignalBus.new_game.connect(_on_new_game);
	SignalBus.popped.connect(_on_ball_popped);
	SignalBus.game_over.connect(_on_game_over);	
	change_head_for_stage(1);
	set_finished_percent(0);

func _process(delta):
	return;
	if not should_start_rotate_counter:
		return;
		
	cur_secs_between_rotation += delta;
	if cur_secs_between_rotation >= total_secs_between_rotation:
		cur_secs_between_rotation -= total_secs_between_rotation;
		if should_rotate_left:
			rotate_left();
		else:
			rotate_right();
		
		should_rotate_left = not should_rotate_left;
		

# uses percent as decimal
func set_finished_percent(percent : float):
	value = max(1 - percent, 0);
	
	if percent <= 0:
		$Face.position = INITIAL_FACE_POSITION;
	elif percent >= 1:
		$Face.position = FINAL_FACE_POSITION;
	else:
		var new_pos = (Vector2(START_OF_METER_POSITION.x - percent * abs(END_OF_METER_POSITION.x - START_OF_METER_POSITION.x), END_OF_METER_POSITION.y));
		$Face.position = new_pos;
		
func change_head_for_stage(stage_number : int):
	if stage_number < 1 or stage_number > len(FACE_GRAPHICS):
		printerr("Bad stage number in score progress indicator: %s" % [stage_number]);
		return;
	
	$Face.texture = FACE_GRAPHICS[stage_number - 1];

func rotate_right():
	$Face.rotate(deg_to_rad(degrees_to_rotate));
	
func rotate_left():
	$Face.rotate(deg_to_rad(-degrees_to_rotate));

func reset_rotation():
	if not should_rotate_left:
		rotate_right();
		should_rotate_left = true;
		cur_secs_between_rotation = 0;

func _on_new_game():
	reset_rotation();
	self.score = 0;
	change_head_for_stage(1);
	
func _on_ball_popped(ball_number):
	should_start_rotate_counter = true;
	self.score += ball_number * 5;
	set_finished_percent(self.score / self.max_score_for_graphics);
	
func _on_game_over():
	should_start_rotate_counter = false;
	self.score = 0;
