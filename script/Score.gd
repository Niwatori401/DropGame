extends RichTextLabel

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.popped.connect(_on_ball_popped)
	self.text = "[center]Score: %s[/center]" % score;

func get_score():
	return self.score;

func _on_ball_popped(ball_type):
	self.score += ball_type * 5
	self.text = "[center]Score: %s[/center]" % score;
	
