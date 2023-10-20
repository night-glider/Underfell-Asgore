extends Control

func _ready():
	$gui/dial.start_dialogue()


func _on_dial_dialogue_ended():
	$gui/dial_cloud.visible = false
	$asgore.play("rage_transition")
	$asgore.offset.x = 37


func _on_asgore_animation_finished():
	get_tree().change_scene("res://scenes/asgore_fight_phase3.tscn")
