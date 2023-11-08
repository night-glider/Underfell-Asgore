extends Control

onready var player = $player
var background_fade = false

var attacks = [
	{"attack": preload("res://attacks/attack2/attack.tscn"),
	 "hard": preload("res://attacks/attack2/hard.tres")},
	{"attack": preload("res://attacks/attack3/attack.tscn"),
	 "hard": preload("res://attacks/attack3/hard.tres")},
	{"attack": preload("res://attacks/attack4/attack.tscn"),
	 "hard": preload("res://attacks/attack4/hard.tres")},
	{"attack": preload("res://attacks/attack5/attack.tscn"),
	 "hard": preload("res://attacks/attack5/hard.tres")},
	{"attack": preload("res://attacks/attack6/attack.tscn"),
	 "hard": preload("res://attacks/attack6/hard.tres")},
	{"attack": preload("res://attacks/attack7/attack.tscn"),
	 "hard": preload("res://attacks/attack7/hard.tres")},
	{"attack": preload("res://attacks/attack8/attack.tscn"),
	 "hard": preload("res://attacks/attack8/hard.tres")},
	]

#var attacks = [
#	{"attack": preload("res://attacks/attack2/attack.tscn"),
#	 "hard": preload("res://attacks/attack2/hard.tres")},
#]

var player_camera:CameraExtended
var attacks_survived = 0

func _ready():
	$battle_framework.init(player)
	_on_player_hp_changed(player.hp)
	
	for node in GlobalGeneral.temp_data:
		$background.add_child(node)
	
	GlobalGeneral.temp_data.clear()
	
	player.position = Vector2(320, 320)
	player_camera = player.camera
	
	_on_battle_framework_attack_ended(null)

func _process(delta):
	if background_fade:
		$background.modulate.a -= 0.0016

func asgore_rage_transition():
	$asgore.play("rage_transition")
	$asgore.offset.x = 37

func _on_player_hp_changed(new_hp):
	$gui/TextureProgress.value = new_hp
	$gui/hp.text = str(new_hp) + "/" + str(player.max_hp)


func _on_battle_framework_attack_ended(_attack):
	var attack_data = attacks.pop_front()
	
	if attack_data == null:
		get_tree().change_scene("res://scenes/fight_phase_3_transition.tscn")
		return
	
	if attacks.empty():
		background_fade = true
	
	var attack = attack_data["attack"].instance()
	var hard = attack_data["hard"]
	attack.set_difficulty(hard, hard, 0)
	$battle_framework.start_attack(attack)
	
	if attacks_survived == 2:
		player.position = Vector2(320, 260)
	
	$ColorRect/AnimationPlayer.play("flash")
	attacks_survived+=1
