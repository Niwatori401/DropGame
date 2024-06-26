extends AnimatedSprite2D

# Minimum score for each sprite level
var point_thresholds = [0, 30, 50, 70, 100, 150, 200, 250];
var current_level = 0;

var score = 0;

func _ready():
	pass

func _process(delta):
	pass

func _on_ball_popped(score):
	var sprite_should_change = false;
	
	self.score += score * 5;
	if self.score >= point_thresholds[len(point_thresholds) - 1] and current_level < len(point_thresholds) - 1:
		current_level = len(point_thresholds) - 1;
		sprite_should_change = true;
	else:
		for i in range(len(point_thresholds) - 1):
			if self.score >= point_thresholds[i] and self.score < point_thresholds[i+1] and current_level != i:
				current_level = i;
				sprite_should_change = true;
				break;
	
	if sprite_should_change:
		play(str(current_level));
	
	
func _on_game_over():
	self.score = 0;
	
func _on_new_game():
	self.score = 0;
	current_level = 0;
	play(str(current_level));

