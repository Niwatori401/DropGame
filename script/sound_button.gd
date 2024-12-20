extends Button


func _on_focus_entered() -> void:
	$TickSFX.play();

func _on_mouse_entered() -> void:
	$TickSFX.play();
