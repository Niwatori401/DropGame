extends Node

signal new_game

var should_fade_out = false;

# RUNNING GAMEOVER
var game_state : String = "RUNNING";

#Prevents submitting the score multiple times due to the ball bouncing on the end line
var submitted_score = false;
func _ready():
	SignalBus.game_over.connect(_on_game_over);
	
	$DarkScreen.show();
	$DarkScreen.modulate.a = 1;
	$GameOver.modulate.a = 0;
	$GameOver.hide();



func _process(delta):
	
	if should_fade_out:
		if $DarkScreen.modulate.a < 0:
			$DarkScreen.modulate.a = 0;
		$BGM.volume_db -= 20 * delta;
		
		$DarkScreen.modulate.a += delta * 0.7;
	else:
		$DarkScreen.modulate.a -= delta * 0.7;
		
	if game_state == "GAMEOVER" and $GameOver.modulate.a < 1:
		$GameOver.modulate.a += delta;
	
	if Input.is_action_just_pressed("restart_game"):
		restart_game();
	
	if Input.is_action_just_pressed("go_back"):
		should_fade_out = true;
		get_tree().create_timer(2).timeout.connect(func(): get_tree().change_scene_to_file("res://scene/level/main_menu.tscn"));


func restart_game():
	$Score/ScoreLabel.score = 0;
	$GameOver/ScoreStatusLabel.set_text("");
	$GameOver.hide();
	$BGM.stop();
	$BGM.play();
	SignalBus.new_game.emit();
	submitted_score = false;

	var nodes_in_group = get_tree().get_nodes_in_group("ball")
	for node in nodes_in_group:
		node.queue_free()
		
	game_state = "RUNNING";


func _on_game_over():
	$GameOver.show();
	if (Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_USEACCOUNT) and !submitted_score):
		submitted_score = true;
		post_new_score_for_user($Score/ScoreLabel.get_score());
		
	self.game_state = "GAMEOVER";

func post_new_score_for_user(score: int):
	$HTTPScoreSubmit.request_completed.connect(self.on_score_submitted)
	$GameOver/ScoreStatusLabel.set_text("[center][color=darkyellow]Submitting score...[/color][/center]");
	var json = '{"passhash":"%s", "userId": {"userName":"%s"}, "score":%d}' % [Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_PASSWORD).hash(), Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_USERNAME), score];
	var headers = ["Content-Type: application/json"]
	var base_url = Config.get_config().get_value(Config.SECTION_APPLICATION, Config.KEY_BASEURL);
	var url = "%s/score/newScore" % base_url
	$HTTPScoreSubmit.request(url, headers, HTTPClient.METHOD_POST, json)

func on_score_submitted(_result, _response_code, _headers, _body):
	$GameOver/ScoreStatusLabel.set_text("[center][color=darkgreen]Score submitted[/color][/center]");
