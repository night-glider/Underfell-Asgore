extends Control

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		GlobalAudio.play_sound(preload("res://audio/choice.wav"))
		$AnimationPlayer.play("fade_in")

func begin_game():
	get_tree().change_scene("res://scenes/throne_room.tscn")
