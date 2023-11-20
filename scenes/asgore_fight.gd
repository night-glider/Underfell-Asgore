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
	},
	{
		"attack": preload("res://attacks/attack6/attack.tscn"),
		"easy": preload("res://attacks/attack6/easy.tres"),
		"hard": preload("res://attacks/attack6/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack7/attack.tscn"),
		"easy": preload("res://attacks/attack7/easy.tres"),
		"hard": preload("res://attacks/attack7/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack8/attack.tscn"),
		"easy": preload("res://attacks/attack8/easy.tres"),
		"hard": preload("res://attacks/attack8/hard.tres")
	},
	{
		"attack": preload("res://attacks/attack9/attack.tscn"),
		"easy": preload("res://attacks/attack9/easy.tres"),
		"hard": preload("res://attacks/attack9/hard.tres")
	}
]
var enemy_hp = 10000

var music_fade_in = false

func _ready():
	$AnimationPlayer.play("start_fade_in")
	$player.hp = 20
	$battle_framework.init($player)
	$battle_gui.main_menu_text = "BATTLE_ASGORE_ATTACKS"
	$battle_gui.init($player, $battle_framework, enemy_hp)
	
	refuse_dials.append(["REFUSE_DIAL1_1", "REFUSE_DIAL1_2", "REFUSE_DIAL1_3", "REFUSE_DIAL1_4"])
	refuse_dials.append(["REFUSE_DIAL2_1", "REFUSE_DIAL2_2", "REFUSE_DIAL2_3"])
	refuse_dials.append(["REFUSE_DIAL4_1", "REFUSE_DIAL4_2", "REFUSE_DIAL4_3", "REFUSE_DIAL4_4", "REFUSE_DIAL4_5", "REFUSE_DIAL4_6"])
	refuse_dials.append(["REFUSE_DIAL5_1", "REFUSE_DIAL5_2", "REFUSE_DIAL5_3", "REFUSE_DIAL5_4", "REFUSE_DIAL5_5"])
	refuse_dials.append(["REFUSE_DIAL6_1", "REFUSE_DIAL6_2", "REFUSE_DIAL6_3", "REFUSE_DIAL6_4"])
	refuse_dials.append(["REFUSE_DIAL7_1", "REFUSE_DIAL7_2", "REFUSE_DIAL7_3", "REFUSE_DIAL7_4", "REFUSE_DIAL7_5"])
	refuse_dials.append(["REFUSE_DIAL8_1", "REFUSE_DIAL8_2", "REFUSE_DIAL8_3"])
	refuse_dials.append(["REFUSE_DIAL9_1", "REFUSE_DIAL9_2", "REFUSE_DIAL9_3", "REFUSE_DIAL9_4"])
	refuse_dials.append(["REFUSE_DIAL10_1", "REFUSE_DIAL10_2", "REFUSE_DIAL10_3"])
	refuse_dials.append(["REFUSE_DIAL11_1", "REFUSE_DIAL11_2", "REFUSE_DIAL11_3"])
	refuse_dials.append(["REFUSE_DIAL12_1", "REFUSE_DIAL12_2", "REFUSE_DIAL12_3"])
	refuse_dials.append(["REFUSE_DIAL13_1", "REFUSE_DIAL13_2", "REFUSE_DIAL13_3"])
	refuse_dials.append(["REFUSE_DIAL14_1", "REFUSE_DIAL14_2", "REFUSE_DIAL14_3"])
	refuse_dials.append(["REFUSE_DIAL15_1", "REFUSE_DIAL15_2", "REFUSE_DIAL15_3"])


func _on_battle_gui_act_pressed(option_id):
	if option_id == "check":
		$battle_gui.start_dialogue(["CHECK_DIAL"])
	if option_id == "refuse":
		if current_refuse_dial>=14:
			$battle_gui.start_dialogue([
				"FIGHT_PHASE1_END_DIAL1",
				"FIGHT_PHASE1_END_DIAL2",
				"FIGHT_PHASE1_END_DIAL3",
				'FIGHT_PHASE1_END_DIAL4',
				"FIGHT_PHASE1_END_DIAL5",
				"FIGHT_PHASE1_END_DIAL6",
				"FIGHT_PHASE1_END_DIAL7"
			])
			current_refuse_dial+=1
			init_2_phase()
			return
		$battle_gui.start_dialogue(refuse_dials[current_refuse_dial])
		current_refuse_dial+=1


func _on_battle_gui_waiting_for_next_state(last_action, additional_args):
	#if last_action != BattleGui.states.PLAYER_ATTACKS:
	#	$battle_gui.to_main_buttons()
	#	return
	if current_refuse_dial>=15:
		go_to_2_phase()
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


func _on_battle_gui_enemy_hp_changed(new_hp):
	if new_hp > 0:
		return
	
	$battle_gui.deactivate()
	$battle_framework.visible = false
	$asgore.shake()
	$asgore.play("defeated_shocked")
	$AnimationPlayer.play("gui_fade_in")

func to_bad_ending():
	get_tree().change_scene("res://scenes/bad_ending.tscn")

func init_2_phase():
	music_fade_in = true

func _process(delta):
	if music_fade_in:
		$AudioStreamPlayer.volume_db = lerp($AudioStreamPlayer.volume_db, -80, 0.001)

func go_to_2_phase():
	var backgorund:Node = $fight_background
	remove_child(backgorund)
	backgorund.owner = null
	
	var particles2D:Node = $Particles2D
	remove_child(particles2D)
	particles2D.owner = null
	
	var particles2D2:Node = $Particles2D2
	remove_child(particles2D2)
	particles2D2.owner = null
	
	GlobalGeneral.temp_data = [backgorund, particles2D, particles2D2]
	
	get_tree().change_scene("res://scenes/asgore_fight_phase2.tscn")

func _on_battle_gui_dialogue_custom_event(data):
	if data == "his_reluctance":
		GlobalAudio.play_music( preload("res://audio/his_reluctance.mp3") )

func skip_refuse_dials():
	current_refuse_dial = len(refuse_dials)

func set_enemy_hp(val):
	enemy_hp = val
	$battle_gui.enemy_hp = val



func _on_battle_framework_attack_custom_event(type, data):
	if type == "change_asgore_sprite":
		$asgore.frame = 0
		$asgore.play(data)
		if data == "attack_blue" or data == "attack_orange":
			$asgore.offset = Vector2(0, 35)
			$asgore.z_index = 999
		else:
			$asgore.offset = Vector2.ZERO
			$asgore.z_index = 0
	if type == "asgore_hflip":
		$asgore.flip_h = data
