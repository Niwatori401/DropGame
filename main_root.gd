extends Node

signal new_game

# RUNNING GAMEOVER
var game_state : String = "RUNNING";

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.modulate.a = 0;
	$GameOver.hide();
	connect("new_game", $Dropper._on_new_game);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_state == "GAMEOVER" and $GameOver.modulate.a < 1:
		$GameOver.modulate.a += delta;
	
	if Input.is_action_just_pressed("restart_game"):
		restart_game();


func restart_game():
	$Score/ScoreLabel.score = 0;
	$GameOver.hide();
	$BGM.stop();
	$BGM.play();
	emit_signal("new_game")

	var nodes_in_group = get_tree().get_nodes_in_group("ball")
	for node in nodes_in_group:
		node.queue_free()
		
	game_state = "RUNNING";


func _on_game_over():
	$GameOver.show();
	self.game_state = "GAMEOVER";
