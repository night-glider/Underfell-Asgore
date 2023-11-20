extends Control

func _ready():
	$gui/dial.start_dialogue()
	var music_player = GlobalAudio.get_music_node()
	if music_player != null:
		$Tween.interpolate_property(music_player, "volume_db", 0, -80, 4)
		$Tween.start()


func _on_dial_dialogue_ended():
	$gui/dial_cloud.visible = false
	$asgore.play("rage_transition")
	$asgore.offset.x = 37
	$Periodic.add_method_oneshot($AudioStreamPlayer, "play", [], 0.25)


func _on_asgore_animation_finished():
	GlobalAudio.stop_music()
	get_tree().change_scene("res://scenes/asgore_fight_phase3.tscn")
