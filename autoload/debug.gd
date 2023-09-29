extends CanvasLayer

var player:Player

func _ready():
	$Panel.visible = false

func player_buttons_init():
	player = get_parent().find_node("player", true, false)
	$Panel/VBoxContainer/heal_player.disabled = player == null

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		$Panel.visible = not $Panel.visible
		player_buttons_init()

func _on_dialogue_debugger_pressed():
	get_tree().change_scene("res://scenes/dialogue_debugger.tscn")
	$Panel.visible = false

func _on_clear_save_pressed():
	OS.alert("FIX ME PLS")

func _on_attacks_debugger_pressed():
	get_tree().change_scene("res://scenes/battle_debug.tscn")
	$Panel.visible = false


func _on_heal_player_pressed():
	player.take_hit(-100)
