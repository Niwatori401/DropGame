extends AnimatedSprite2D



# Minimum score for each sprite level
var point_thresholds = [0, 200, 500, 1000, 1750, 2750, 3000, 5000];
var current_level = 0;

var score = 0;

func _ready():
	SignalBus.new_game.connect(_on_new_game);
	SignalBus.popped.connect(_on_ball_popped);
	SignalBus.game_over.connect(_on_game_over);


func _on_ball_popped(ball_number):
	var sprite_should_change = false;
	
	self.score += ball_number * 5;
	if self.score >= point_thresholds[len(point_thresholds) - 1] and current_level < len(point_thresholds) - 1:
		SignalBus.stage_changed.emit(len(point_thresholds));
		current_level = len(point_thresholds) - 1;
		sprite_should_change = true;
	else:
		for i in range(len(point_thresholds) - 1):
			if self.score >= point_thresholds[i] and self.score < point_thresholds[i+1] and current_level != i:
				current_level = i;
				SignalBus.stage_changed.emit(i + 1);
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

