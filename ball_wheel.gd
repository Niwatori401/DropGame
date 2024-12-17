extends Sprite2D

var mystery_tex = preload("res://art/mystery_icon.png");
var ball_nodes = [
	"ball1icon",
	"ball2icon",
	"ball3icon",
	"ball4icon",
	"ball5icon",
	"ball6icon",
	"ball7icon",
	"ball8icon"
]
var ball_texture = [preload("res://art/ball1.png"), \
					preload("res://art/ball2.png"), \
					preload("res://art/ball3.png"), \
					preload("res://art/ball4.png"), \
					preload("res://art/ball5.png"), \
					preload("res://art/ball6.png"), \
					preload("res://art/ball7.png"), \
					preload("res://art/ball8.png")]
var ball_revealed = [true, true, false, false, false, false, false, false];


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.popped.connect(_on_ball_popped);
	SignalBus.game_over.connect(_on_game_over);
	update_textures();

func update_textures():
	for i in range(len(ball_revealed)):
		if ball_revealed[i]:
			get_node(ball_nodes[i]).texture = ball_texture[i];
		else:
			get_node(ball_nodes[i]).texture = mystery_tex;

func _on_ball_popped(ball_type):
	if ball_type > 8:
		return;
	
	if not ball_revealed[ball_type - 1]:
		ball_revealed[ball_type - 1] = true;
		update_textures();

	
func _on_game_over():
	pass
