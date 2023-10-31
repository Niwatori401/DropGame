extends Node

var base_url = "http://localhost:8080"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_user("BILLY", "BOBBY");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_user(username: String, password: String):
	var hashed_pass = password.hash();
	# $Http.request_completed.connect()
	var json = '{"namePassHash": {"userName": "%s", "passHash": "%s"}}' % [username, hashed_pass];
	var headers = ["Content-Type: application/json"]
	var url = "%s/user/createUser" % base_url
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)


func get_all_scores_for_user(username: String):
	var url = "%s/score/userScores/%s" % [base_url, username]
	$HTTPRequest.request(url);
	
	
func post_new_score_for_user(username: String, score: int):
	# $Http.request_completed.connect()
	var json = '{"userId": {"userName":"%s"}, "score":%d}' % [username, score];
	var headers = ["Content-Type: application/json"]
	var url = "%s/score/newScore" % base_url
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
	

func get_user_by_username_password(username: String, password: String):
	var url = "%s/user/getUser/%s/%s" % [base_url, username, password.hash()]
	$HTTPRequest.request(url);

	

#var json = JSON.stringify(data_to_send)
#var headers = ["Content-Type: application/json"]
#$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
#func _on_request_completed(result, response_code, headers, body):
#	var json = JSON.parse_string(body.get_string_from_utf8())
#	print(json["name"])
