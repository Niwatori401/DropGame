extends RigidBody2D

@export var ball_type : int = 1
@export var base_scale : float = 4.675
var is_hovered_over = false;

var ball_size = 1.0
var should_teleport : bool = false
var should_launch: bool = false;
var teleport_location : Vector2 = Vector2.ZERO
var launch_velocity: Vector2 = Vector2.ZERO
@export var flip_sprite : bool = false;


func _ready():
	get_node("Hitbox/Sprite").play(str(self.ball_type))
	if flip_sprite:
		get_node("Hitbox/Sprite").flip_h = true;
	update_scale()
	

func update_scale():
	$Hitbox.scale = Vector2(base_scale * ball_size, base_scale * ball_size)

func _input(event):
	if event is InputEventMouseMotion and is_hovered_over:
		launch_velocity = event.get_velocity() * Vector2(0.5,0.5);	
	
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and is_hovered_over:
		should_teleport = true;
	elif Input.is_action_just_released("left_click"):
		should_launch = true;
	

func _integrate_forces(state):
	# Fixes a weird graphical issue where when spawned these balls would be super stretched.
	self.visible = true
	if should_teleport:
		state.linear_velocity = Vector2(0 ,0);
		state.transform.origin = get_global_mouse_position();
		should_teleport = false;
		
	elif should_launch:
		should_launch = false;
		state.linear_velocity = launch_velocity;



func _on_mouse_shape_entered(shape_idx):
	is_hovered_over = true;


func _on_mouse_shape_exited(shape_idx):
	is_hovered_over = false;
