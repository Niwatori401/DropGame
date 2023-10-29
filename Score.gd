extends RichTextLabel

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Score: " + str(score)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Score: " + str(score)


func _on_ball_popped(ball_type):
	print("POPPPPPPED")
	self.score += ball_type * 100
	self.text = "Score: " + str(score)
	
