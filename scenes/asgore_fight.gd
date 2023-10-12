extends Control

var refuse_dials = []
var current_refuse_dial = 0
var attacks = [
	{
		"attack": preload("res://attacks/attack2/attack.tscn"),
		"easy": preload("res://attacks/attack2/easy.tres"),
		"hard": preload("res://attacks/attack2/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack3/attack.tscn"),
		"easy": preload("res://attacks/attack3/easy.tres"),
		"hard": preload("res://attacks/attack3/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack4/attack.tscn"),
		"easy": preload("res://attacks/attack4/easy.tres"),
		"hard": preload("res://attacks/attack4/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack5/attack.tscn"),
		"easy": preload("res://attacks/attack5/easy.tres"),
		"hard": preload("res://attacks/attack5/hard.tres")
	}
]
var enemy_hp = 1000

func _ready():
	$player.hp = 1
	$battle_framework.init($player)
	$battle_gui.main_menu_text = "BATTLE_ASGORE_ATTACKS"
	$battle_gui.init($player, $battle_framework, enemy_hp)
	
	refuse_dials.append(["REFUSE_DIAL1_1", "REFUSE_DIAL1_2"])
	refuse_dials.append(["REFUSE_DIAL2_1", "REFUSE_DIAL2_2", "REFUSE_DIAL2_3"])
	refuse_dials.append(["REFUSE_DIAL3_1", "REFUSE_DIAL3_2", "REFUSE_DIAL3_3"])
	refuse_dials.append(["REFUSE_DIAL4_1", "REFUSE_DIAL4_2"])
	refuse_dials.append(["REFUSE_DIAL5_1", "REFUSE_DIAL5_2"])
	refuse_dials.append(["REFUSE_DIAL6_1", "REFUSE_DIAL6_2", "REFUSE_DIAL6_3"])
	refuse_dials.append(["REFUSE_DIAL7_1", "REFUSE_DIAL7_2"])
	refuse_dials.append(["REFUSE_DIAL8_1", "REFUSE_DIAL8_2", "REFUSE_DIAL8_3"])
	refuse_dials.append(["REFUSE_DIAL9_1", "REFUSE_DIAL9_2"])
	refuse_dials.append(["REFUSE_DIAL10_1", "REFUSE_DIAL10_2"])
	refuse_dials.append(["REFUSE_DIAL11_1", "REFUSE_DIAL11_2"])
	refuse_dials.append(["REFUSE_DIAL12_1", "REFUSE_DIAL12_2"])
	refuse_dials.append(["REFUSE_DIAL13_1", "REFUSE_DIAL13_2"])
	refuse_dials.append(["REFUSE_DIAL14_1", "REFUSE_DIAL14_2"])


func _on_battle_gui_act_pressed(option_id):
	if option_id == "check":
		$battle_gui.start_dialogue(["CHECK_DIAL"])
	if option_id == "refuse":
		if current_refuse_dial>=14:
			OS.alert("crash time")
			return
		$battle_gui.start_dialogue(refuse_dials[current_refuse_dial])
		current_refuse_dial+=1


func _on_battle_gui_waiting_for_next_state(last_action, additional_args):
	if last_action != BattleGui.states.PLAYER_ATTACKS:
		$battle_gui.to_main_buttons()
		return
	
	var attack_data = attacks[randi() % len(attacks)]
	var attack = attack_data["attack"].instance()
	var easy = attack_data["easy"]
	var hard = attack_data["hard"]
	attack.set_difficulty(easy, hard, randf())
	$battle_gui.enemy_attacks(attack)


func _on_battle_framework_attack_ended(attack:Attack):
	$battle_gui.to_main_buttons_delay(0.1)

func _on_battle_gui_item_consumed(item:HealItem):
	if item.short_name == "ITEM_PIE":
		$player.additional_damage += 1

func get_main_menu_text():
	return "BATTLE_ASGORE_ATTACKS"
