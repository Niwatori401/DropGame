extends Node

@onready var score_board_container = get_tree().get_nodes_in_group("player_score_container")[0];
@onready var personal_score_container = get_tree().get_nodes_in_group("personal_score_container")[0]; 
var score_entry_template = preload("res://score_entry.tscn")

var current_index = 0;
var amount_per_page = 10;


var base_url = "http://localhost:8080"

func _ready():
	get_user_by_name("DaneJ");
	get_n_users_from_m(amount_per_page, current_index);

func get_user_by_name(username: String):
	$HTTPGetCurrentUser.request_completed.connect(_on_get_current_user_request_completed)
	var url = "%s/user/getUser/%s/rank" % [base_url, username]
	$HTTPGetCurrentUser.request(url);

func get_n_users_from_m(n: int, m: int):
	$HTTPGetScoreBoard.request_completed.connect(_on_get_score_board_request_completed)
	$HTTPGetScoreBoard.request("%s/user/getLeaderboard/%d/%d" % [base_url, n, m])

func _on_next_button_pressed():
	current_index += amount_per_page;
	for node in score_board_container.get_children():
		node.queue_free();
		
	get_n_users_from_m(amount_per_page, current_index);

func _on_previous_button_pressed():
	if current_index == 0:
		return;
		
	current_index -= amount_per_page;
	if current_index < 0:
		current_index = 0;
		
	for node in score_board_container.get_children():
		node.queue_free();
		
	get_n_users_from_m(amount_per_page, current_index);


func _on_get_current_user_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	var score_instance = score_entry_template.instantiate();
	score_instance.get_node("ScoreLabel").set_text(str(json["topScore"]));
	score_instance.get_node("PlayerNameLabel").set_text(json["namePassHash"]["userName"]);
	score_instance.get_node("RankingLabel").set_text(str(json["rank"]));
	personal_score_container.add_child(score_instance);


func _on_get_score_board_request_completed(result, response_code, headers, body):
	if response_code != 200:
		return;
		
	var json = JSON.parse_string(body.get_string_from_utf8())
	var y_init_offset = 45;
	var y_offset = 45;
	var i = 0;
	
	for j in json:
		var score_instance = score_entry_template.instantiate();
		score_instance.get_node("ScoreLabel").set_text(str(j["topScore"]));
		score_instance.get_node("PlayerNameLabel").set_text(j["namePassHash"]["userName"]);
		score_instance.get_node("RankingLabel").set_text(str(j["rank"]));
		score_instance.translate(Vector2(0, i * y_offset + y_init_offset));
		score_board_container.add_child(score_instance);
		
		i += 1;


#var json = JSON.stringify(data_to_send)
#var headers = ["Content-Type: application/json"]
#$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


#func add_user(username: String, password: String):
#	var hashed_pass = password.hash();
#	# $Http.request_completed.connect()
#	var json = '{"namePassHash": {"userName": "%s", "passHash": "%s"}}' % [username, hashed_pass];
#	var headers = ["Content-Type: application/json"]
#	var url = "%s/user/createUser" % base_url
#	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


#func get_all_scores_for_user(username: String):
	#$HTTPGetCurrentUser.request_completed.connect(_on_get_current_user_request_completed)
	#var url = "%s/score/userScores/%s" % [base_url, username]
	#$HTTPGetCurrentUser.request(url);
	
	
#func post_new_score_for_user(username: String, score: int):
#	# $Http.request_completed.connect()
#	var json = '{"userId": {"userName":"%s"}, "score":%d}' % [username, score];
#	var headers = ["Content-Type: application/json"]
#	var url = "%s/score/newScore" % base_url
#	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
	


