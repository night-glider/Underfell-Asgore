extends Control

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		GlobalAudio.play_sound(preload("res://audio/choice.wav"))
		get_tree().change_scene("res://scenes/start_logo.tscn")
