extends RigidBody2D
signal popped(ball_type)

@export var ball_type : int = 1
@export var max_ball_type : int = 8
@export var base_scale : float = 4.675

var ball_sizes = [0.6, 0.75, .9, 1.1, 1.3, 1.5, 2.0, 2.5]
var ball_masses = [0.6, 0.75, .9, 1.1, 1.3, 1.5, 2.0, 2.5]
var should_teleport : bool = false
var teleport_location : Vector2 = Vector2.ZERO

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(15)
	get_node("Hitbox/Sprite").play(str(self.ball_type))
	update_scale()
	

func update_scale():
	$Hitbox.scale = Vector2(base_scale * ball_sizes[self.ball_type - 1], base_scale * ball_sizes[self.ball_type - 1])
	self.mass = ball_masses[self.ball_type - 1]
	
func _process(delta):
	pass

func _integrate_forces(state):
	# Fixes a weird graphical issue where when spawned these balls would be super stretched.
	self.visible = true
	if should_teleport:
		state.transform.origin = teleport_location
		should_teleport = false

func _on_body_entered(body):
	if body.is_in_group("ball") and body.ball_type == self.ball_type and body.ball_type < self.max_ball_type:
		self.ball_type += 1
		should_teleport = true
		get_node("Hitbox/Sprite").play(str(self.ball_type))
		update_scale()
		var start_loc = self.get_global_transform().get_origin()
		var end_loc = body.get_global_transform().get_origin()
		self.teleport_location = (start_loc + end_loc) / 2

		emit_signal("popped", self.ball_type)
		body.queue_free()
			
