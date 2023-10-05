extends Control

func _ready():
	$player.hp = 1
	$battle_framework.init($player)
	$battle_gui.init($player, $battle_framework)


func _on_battle_gui_act_pressed(option_id):
	if option_id == "check":
		$battle_gui.start_dialogue(["check pressed! no way.."])
	if option_id == "refuse":
		$battle_gui.start_dialogue(["refuse pressed!"])


func _on_battle_gui_waiting_for_next_state(last_action, additional_args):
	if last_action != BattleGui.states.PLAYER_ATTACKS:
		$battle_gui.to_main_buttons()
		return
	
	var attack = preload("res://attacks/attack2/attack.tscn").instance()
	var easy = preload("res://attacks/attack2/easy.tres")
	var hard = preload("res://attacks/attack2/hard.tres")
	attack.set_difficulty(easy, hard, randf())
	$battle_gui.enemy_attacks(attack)


func _on_battle_framework_attack_ended(attack):
	$battle_gui.to_main_buttons()
