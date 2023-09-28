extends CanvasLayer

func _ready():
	$Panel.visible = false

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		$Panel.visible = not $Panel.visible

func _on_dialogue_debugger_pressed():
	get_tree().change_scene("res://scenes/dialogue_debugger.tscn")

func _on_clear_save_pressed():
	OS.alert("FIX ME PLS")

func _on_attacks_debugger_pressed():
	get_tree().change_scene("res://scenes/battle_debug.tscn")
