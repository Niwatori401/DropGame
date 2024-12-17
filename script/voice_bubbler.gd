extends AudioStreamPlayer

@export var voice_bubbles : Array[AudioStream];



func play_bubble_letter(letter : String) -> void:
	if letter == " " or letter == "," or letter == ".":
		return;
	
	stream.stop();	
	stream = voice_bubbles.pick_random();
	stream.play();
