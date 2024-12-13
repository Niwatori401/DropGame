extends Node

var open_tong = preload("res://art/mouse/tong_open.png");
var close_tong = preload("res://art/mouse/tong_close.png"); 


func _ready():
	Input.set_custom_mouse_cursor(open_tong, Input.CURSOR_ARROW);

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		Input.set_custom_mouse_cursor(close_tong, Input.CURSOR_ARROW);
	
	if Input.is_action_just_released("left_click"):
		Input.set_custom_mouse_cursor(open_tong, Input.CURSOR_ARROW);
