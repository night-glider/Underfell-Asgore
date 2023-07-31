extends Node2D


func _ready():
	$AnimationPlayer.play("to_barier")

func start_dialogue():
	$CanvasLayer/DialogueLabel.start_dialogue()

func _on_DialogueLabel_dialogue_ended():
	get_tree().change_scene("res://scenes/barrier.tscn")
