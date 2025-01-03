extends RigidBody2D

@export var ball_type : int = 1
@export var max_ball_type : int = 8
@export var base_scale : float = 4.675

var ball_sizes = [0.4, 0.6, .8, 1.0, 1.2, 1.4, 1.6, 1.0]
var ball_masses = [0.6, 0.75, .9, 1.1, 1.3, 1.5, 2.0, 2.5]
var ball_pitches = [1, 0.8, 0.7, 0.6, 0.5, 0.4, 0.25, 0.1]
var should_teleport : bool = false
var teleport_location : Vector2 = Vector2.ZERO
@export var time_since_last_check : float;
@export var time_between_checks : float = 1;

var time_since_thud : float = 0;
var time_between_thuds : float = 0.5;
var time_to_thudless : float = 0;
var time_until_thudless : float = 6;

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(15)
	get_node("Hitbox/Sprite").play(str(self.ball_type))
	update_scale()
	

func update_scale():
	$Hitbox.scale = Vector2(base_scale * ball_sizes[self.ball_type - 1], base_scale * ball_sizes[self.ball_type - 1])
	self.mass = ball_masses[self.ball_type - 1]
	
func _process(delta):
	time_since_thud += delta;
	time_since_last_check += delta;
	
	if time_since_last_check >= time_between_checks:
		var coliBodies = get_colliding_bodies()
		time_since_last_check = 0;
		
		for body in coliBodies:
			if body.is_in_group("ball") and body.ball_type == self.ball_type and body.ball_type < self.max_ball_type:
				pop_ball(body);
	

func _integrate_forces(state):
	# Fixes a weird graphical issue where when spawned these balls would be super stretched.
	self.visible = true
	if should_teleport:
		state.transform.origin = teleport_location
		should_teleport = false

func _on_body_entered(body):
	if time_since_thud > time_between_thuds and time_to_thudless < time_until_thudless:
		$Thud.set_pitch_scale(self.ball_pitches[self.ball_type - 1]);
		$Thud.play();
		time_to_thudless += time_since_thud;
		time_since_thud = 0;
		
	if body.is_in_group("FailLine"):
		SignalBus.game_over.emit();
		
	if body.is_in_group("ball") and body.ball_type == self.ball_type and body.ball_type < self.max_ball_type:
		pop_ball(body);
			

func pop_ball(body):
	self.ball_type += 1
	should_teleport = true
	get_node("Hitbox/Sprite").play(str(self.ball_type))
	update_scale()
	var start_loc = self.get_global_transform().get_origin()
	var end_loc = body.get_global_transform().get_origin()
	self.teleport_location = (start_loc + end_loc) / 2
	$Pop.set_pitch_scale(self.ball_pitches[self.ball_type - 1]);
	$Pop.play();

	SignalBus.popped.emit(self.ball_type);
	body.queue_free()
