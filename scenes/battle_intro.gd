extends Control

func _ready():
	$AnimationPlayer.play("fade_in")

func start_scythe():
	$AnimationPlayer.play("scythe")

func scythe_rotation():
	$AnimationPlayer.play("scythe_rotation")
	$scythe.enable_rotation()

func scythe_swing():
	$AnimationPlayer.play("scythe_swing")

func to_battle():
	get_tree().change_scene("res://scenes/asgore_fight.tscn")
