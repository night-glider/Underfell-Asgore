extends Node2D


func _ready():
	$AnimationPlayer.play("to_barier")

func start_dialogue():
	$CanvasLayer/DialogueLabel.start_dialogue()

func _on_DialogueLabel_dialogue_ended():
	OS.alert("fuck")
