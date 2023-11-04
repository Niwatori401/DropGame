extends Node

signal new_game

var should_fade_out = false;

# RUNNING GAMEOVER
var game_state : String = "RUNNING";

var config = ConfigFile.new();
var base_url = "http://localhost:8080"

#Prevents submitting the score multiple times due to the ball bouncing on the end line
var submitted_score = false;
func _ready():
	$DarkScreen.show();
	$DarkScreen.modulate.a = 1;
	$GameOver.modulate.a = 0;
	$GameOver.hide();
	config.load("user://config.cfg");
	connect("new_game", $Dropper._on_new_game);
	connect("new_game", $Character._on_new_game);
	

func _process(delta):
	
	if should_fade_out:
		if $DarkScreen.modulate.a < 0:
			$DarkScreen.modulate.a = 0;
		
		$DarkScreen.modulate.a += delta * 0.7;
	else:
		$DarkScreen.modulate.a -= delta * 0.7;
		
	if game_state == "GAMEOVER" and $GameOver.modulate.a < 1:
		$GameOver.modulate.a += delta;
	
	if Input.is_action_just_pressed("restart_game"):
		restart_game();
	
	if Input.is_action_just_pressed("go_back"):
		should_fade_out = true;
		get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"));


func restart_game():
	$Score/ScoreLabel.score = 0;
	$GameOver.hide();
	$BGM.stop();
	$BGM.play();
	emit_signal("new_game")
	submitted_score = false;

	var nodes_in_group = get_tree().get_nodes_in_group("ball")
	for node in nodes_in_group:
		node.queue_free()
		
	game_state = "RUNNING";


func _on_game_over():
	$GameOver.show();
	if (config.get_value("account", "useAccount") and !submitted_score):
		submitted_score = true;
		post_new_score_for_user($Score/ScoreLabel.get_score());
		
	self.game_state = "GAMEOVER";

func post_new_score_for_user(score: int):
	$HTTPScoreSubmit.request_completed.connect(self.on_score_submitted)
	$GameOver/ScoreStatusLabel.set_text("[center][color=darkyellow]Submitting score...[/color][/center]");
	var json = '{"passhash":"%s", "userId": {"userName":"%s"}, "score":%d}' % [config.get_value("account", "password").hash(), config.get_value("account", "username"), score];
	var headers = ["Content-Type: application/json"]
	var url = "%s/score/newScore" % base_url
	$HTTPScoreSubmit.request(url, headers, HTTPClient.METHOD_POST, json)

func on_score_submitted(result, response_code, headers, body):
	$GameOver/ScoreStatusLabel.set_text("[center][color=darkgreen]Score submitted[/color][/center]");
