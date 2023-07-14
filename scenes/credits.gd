extends Control

func _ready():
	$AnimationPlayer.play("fade_out")

func _logo_sound():
	GlobalAudio.play_sound(preload("res://audio/logo.mp3"))

func roll_credits():
	$AnimationPlayer.play("roll")

func end_credits():
	get_tree().change_scene("res://scenes/start_logo.tscn")
