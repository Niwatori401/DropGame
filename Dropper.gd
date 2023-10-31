extends Sprite2D
var position_offset : float = 0
const move_speed = 800
@export var ball_scene : PackedScene
@onready var score_counter = get_tree().get_nodes_in_group("score")[0]
@onready var mainnode = get_tree().get_nodes_in_group("main")[0]
@onready var character_sprite = get_tree().get_nodes_in_group("character")[0]

const ball_sprite_scale_for_next = 0.18;
const ball_sprite_scale_for_next_next = 0.14;
var can_drop = true;
var can_move = true;

var current_ball_index : int
var next_ball_index : int
var next_next_ball_index : int


var ball_sprite_size : Vector2
var rail_length : float

func _ready():
	self.next_ball_index = get_random_index()
	self.next_next_ball_index = get_random_index()
	
	spawn_new_ball_texture()
	self.rail_length = texture.get_width() * scale.x

func _process(delta):
	if !can_move:
		return;
		
	if Input.is_action_pressed("move_left"):
		position_offset -= delta * move_speed
	if Input.is_action_pressed("move_right"):
		position_offset += delta * move_speed
	if Input.is_action_just_pressed("drop_ball") and can_drop:
		can_drop = false;
		$DropTimer.start();
		$DropperHead/BallTexture.modulate.a = 0;
		# Drop current ball
		spawn_falling_ball();
		
	
	if position_offset < (-self.rail_length / 2 + ball_sprite_size[0] / 2)  / global_scale[0]:
		position_offset = (-self.rail_length / 2 + ball_sprite_size[0] / 2) / global_scale[0]
	if position_offset > (self.rail_length / 2 - ball_sprite_size[0] / 2) / global_scale[0]:
		position_offset = (self.rail_length / 2 - ball_sprite_size[0] / 2)  / global_scale[0]
	
	$DropperHead.transform.origin[0] = position_offset

func _on_new_game():
	can_move = true;


func spawn_falling_ball():
	var newball = ball_scene.instantiate()
	# Before the first call to the _integrate_forces() function the graphics for the new ball are glitchy.
	newball.visible = false
	add_child(newball)
	newball.global_position = $DropperHead.global_position

	newball.ball_type = self.current_ball_index
	newball.get_node("Hitbox/Sprite").play(str(newball.ball_type))
	newball.update_scale()
	newball.connect("popped", character_sprite._on_ball_popped)
	newball.connect("popped", score_counter._on_ball_popped)
	newball.connect("game_over", character_sprite._on_game_over)
	newball.connect("game_over", mainnode._on_game_over)
	newball.connect("game_over", self._on_game_over)
	

func _on_game_over():
	can_move = false;

func get_random_index():
	var randval = randf()
	
	if randval < 0.4:
		return 1
	elif randval < 0.7:
		return 2
	elif randval < 0.85:
		return 3
	else:
		return 4

func spawn_new_ball_texture():

	self.current_ball_index = self.next_ball_index
	self.next_ball_index = self.next_next_ball_index
	self.next_next_ball_index = get_random_index()
	
	var newball = ball_scene.instantiate()

	#Set next ball texture
	var next_ball_sprite = newball.get_node("Hitbox/Sprite").get_sprite_frames().get_frame_texture(str(self.next_ball_index), 0)
	get_node("NextBallBackground/Ball").set_texture(next_ball_sprite)
	get_node("NextBallBackground/Ball").scale = Vector2(ball_sprite_scale_for_next, ball_sprite_scale_for_next) / $NextBallBackground.global_scale
	
	#Set next next ball texture
	var next_next_ball_sprite = newball.get_node("Hitbox/Sprite").get_sprite_frames().get_frame_texture(str(self.next_next_ball_index), 0)
	get_node("NextNextBallBackground/Ball").set_texture(next_next_ball_sprite)
	get_node("NextNextBallBackground/Ball").scale = Vector2(ball_sprite_scale_for_next_next, ball_sprite_scale_for_next_next) / $NextNextBallBackground.global_scale
	
	#Set cur ball texture and scale	
	newball.ball_type = self.current_ball_index	
	newball.update_scale()
	
	var cur_ball_sprite = newball.get_node("Hitbox/Sprite").get_sprite_frames().get_frame_texture(str(self.current_ball_index), 0)
	var ball_texture_node = get_node("DropperHead/BallTexture")
	ball_texture_node.set_texture(cur_ball_sprite)
	var orginal_scale = newball.get_node("Hitbox/Sprite").global_scale
	ball_texture_node.scale = orginal_scale / ($DropperHead.scale * self.scale)
	self.ball_sprite_size = orginal_scale * Vector2(ball_texture_node.texture.get_width(), ball_texture_node.texture.get_height())
	
	newball.queue_free()


func _on_drop_timer_timeout():
	$DropTimer.stop();
	$DropperHead/BallTexture.modulate.a = 1;
	# Spawn new ball
	spawn_new_ball_texture();
	can_drop = true;
