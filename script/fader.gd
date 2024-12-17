extends Control


enum FADE_DIRECTION { DARKEN, LIGHTEN, OFF }
var fade_mode : FADE_DIRECTION = FADE_DIRECTION.OFF;

var cur_fade_seconds = 0;
var goal_fade_seconds = 0;
var fade_speed = 100;

func _ready() -> void:
	visible = true;


func _process(delta: float) -> void:
	if fade_mode == FADE_DIRECTION.OFF:
		return;
		
	if cur_fade_seconds >= goal_fade_seconds:
		fade_mode = FADE_DIRECTION.OFF;
		return;
	
	cur_fade_seconds += delta;
	
	if fade_mode == FADE_DIRECTION.DARKEN:
		$ColorRect.modulate.a = clampf(cur_fade_seconds / goal_fade_seconds, 0, 1);
	else:
		$ColorRect.modulate.a = clampf(1 - cur_fade_seconds / goal_fade_seconds, 0, 1);


func darken(seconds_to_fade : float):
	visible = true;
	cur_fade_seconds = 0;
	goal_fade_seconds = seconds_to_fade;
	fade_mode = FADE_DIRECTION.DARKEN;
	
func lighten(seconds_to_fade : float):
	visible = true;
	cur_fade_seconds = 0;
	goal_fade_seconds = seconds_to_fade;
	fade_mode = FADE_DIRECTION.LIGHTEN;
	
