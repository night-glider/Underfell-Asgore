extends CanvasLayer

var player:Player

export var scenes_to_tp = {
	"restart": ("res://scenes/disclaimer.tscn"),
	"main menu": ("res://scenes/main_menu.tscn"),
	"throne room": ("res://scenes/throne_room.tscn"),
	"battle intro": ("res://scenes/battle_intro.tscn"),
	"battle": ("res://scenes/barrier.tscn"),
	"game over": ("res://scenes/game_over.tscn"),
	"bad ending": ("res://scenes/bad_ending.tscn"),
	"bad ending epilogue": ("res://scenes/bad_ending_epiloge.tscn")
}

func _ready():
	for elem in scenes_to_tp.keys():
		$Panel/VBoxContainer/tp_to_scene.add_item(elem)
	
	restart()

func restart():
	$Panel.visible = false
	$Panel/VBoxContainer/tp_to_scene.select(-1)
	$Panel/VBoxContainer/tp_to_scene.text = "teleport to scene"

func player_buttons_init():
	player = get_parent().find_node("player", true, false)
	$Panel/VBoxContainer/heal_player.disabled = player == null
	$Panel/VBoxContainer/heal_player.text = "game over: "
	if player == null:
		$Panel/VBoxContainer/heal_player.text += "off"
		return
	
	if player.game_over_active:
		$Panel/VBoxContainer/heal_player.text += "on"
	else:
		$Panel/VBoxContainer/heal_player.text += "off"

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		$Panel.visible = not $Panel.visible
		player_buttons_init()

func _on_dialogue_debugger_pressed():
	get_tree().change_scene("res://scenes/dialogue_debugger.tscn")
	restart()

func _on_clear_save_pressed():
	OS.alert("FIX ME PLS")

func _on_attacks_debugger_pressed():
	get_tree().change_scene("res://scenes/battle_debug.tscn")
	restart()


func _on_heal_player_pressed():
	player.game_over_active = not player.game_over_active
	
	$Panel/VBoxContainer/heal_player.text = "game over: "
	if player.game_over_active:
		$Panel/VBoxContainer/heal_player.text += "on"
	else:
		$Panel/VBoxContainer/heal_player.text += "off"


func _on_tp_to_scene_item_selected(index):
	get_tree().change_scene( scenes_to_tp[$Panel/VBoxContainer/tp_to_scene.get_item_text(index)])
	restart()
	
