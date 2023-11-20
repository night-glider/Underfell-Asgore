extends Control

func _ready():
	$Periodic.add_method_oneshot(self, "start_dialogue", [], 3)
	$Tween.interpolate_property($ColorRect, "color", Color.white, Color(1,1,1,0), 3)
	$Tween.start()

func start_dialogue():
	$gui/dial_cloud.visible = true
	$gui/dial.start_dialogue()


func _on_dial_dialogue_ended():
	$gui/dial_cloud.visible = false
	$Tween.interpolate_property($ColorRect, "color", Color(1,1,1,0), Color.white, 3)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "go_to_overworld", [], 3)
	GlobalAudio.stop_all_sounds()

func go_to_overworld():
	get_tree().change_scene("res://scenes/ending_overworld.tscn")
