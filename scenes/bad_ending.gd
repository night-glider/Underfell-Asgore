extends Control


func _ready():
	$dial.start_dialogue()


func _on_dial_dialogue_ended():
	$AnimationPlayer.play("suicide")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/bad_ending_epiloge.tscn")
