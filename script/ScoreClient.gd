extends Node

@onready var score_board_container = get_tree().get_nodes_in_group("player_score_container")[0];
@onready var personal_score_container = get_tree().get_nodes_in_group("personal_score_container")[0]; 
var score_entry_template = preload("res://scene/score_entry.tscn")

var current_index = 0;
var amount_per_page = 10;
var total_records: int = 0;

var base_url : String;

func _ready():
	base_url = Config.get_config().get_value(Config.SECTION_APPLICATION, Config.KEY_BASEURL, "");
	if base_url == "":
		printerr("Bad config for URL, using default.");
		base_url = Config.DEFAULT_URL;
		
	get_user_by_name(Config.get_config().get_value(Config.SECTION_ACCOUNT, Config.KEY_USERNAME));
	get_n_users_from_m(amount_per_page, current_index);
	get_user_count();
	
func get_user_by_name(username: String):
	$HTTPGetCurrentUser.request_completed.connect(_on_get_current_user_request_completed)
	var url = "%s/user/getUser/%s/rank" % [base_url, username]
	$HTTPGetCurrentUser.request(url);

func get_n_users_from_m(n: int, m: int):
	$HTTPGetScoreBoard.request_completed.connect(_on_get_score_board_request_completed)
	$HTTPGetScoreBoard.request("%s/user/getLeaderboard/%d/%d" % [base_url, n, m])

func get_user_count():
	$HTTPGetUserCount.request_completed.connect(on_get_user_count_completed)
	$HTTPGetUserCount.request("%s/user/getUserCount" % [base_url], ["Access-Control-Allow-Origin: *"], HTTPClient.METHOD_GET);

func on_get_user_count_completed(result, response_code, headers, body):
	if response_code == 0 or (response_code >= 400 and response_code < 500):
		print("Client error, CODE: %s" % response_code);
	elif response_code >= 500:
		print("Server error, CODE: %s" % response_code);
	else:
		self.total_records = JSON.parse_string(body.get_string_from_utf8())
	

func _on_next_button_pressed():
	if (current_index + amount_per_page > total_records):
		return;
		
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


func _on_get_current_user_request_completed(result, _response_code, _headers, body):
	if (result != OK):
		return;
		
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	var score_instance = score_entry_template.instantiate();
	score_instance.get_node("ScoreLabel").set_text(str(json["topScore"]));
	score_instance.get_node("PlayerNameLabel").set_text(json["namePassHash"]["userName"]);
	score_instance.get_node("RankingLabel").set_text("#" + str(json["rank"]));
	personal_score_container.add_child(score_instance);


func _on_get_score_board_request_completed(_result, response_code, _headers, body):
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
		score_instance.get_node("RankingLabel").set_text("#" + str(j["rank"]));
		score_instance.translate(Vector2(0, i * y_offset + y_init_offset));
		score_board_container.add_child(score_instance);
		
		i += 1;

	


