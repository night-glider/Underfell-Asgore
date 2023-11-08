extends Control

onready var shards = [
	$gui/main_buttons/fight/shard1,
	$gui/main_buttons/fight/shard2,
	$gui/main_buttons/act/shard1,
	$gui/main_buttons/act/shard2,
	$gui/main_buttons/item/shard1,
	$gui/main_buttons/item/shard2,
]
var shards_original_pos = []
var shards_vel = []
var active_falling_shards = []
var shards_shake = [false,false,false,false,false,false]

var fight_broken = false
var act_broken = false
var item_broken = false

func _ready():
	$ColorRect/AnimationPlayer.play("fade_out")
	
	for shard in shards:
		shards_original_pos.append(shard.position)
		shards_vel.append( Vector2.ZERO )
	
	$battle_framework.init($player)
	
	_on_player_hp_changed($player.hp)
	
	next_attack()

func _process(delta):
	process_shard_shake()
	
	for i in active_falling_shards:
		shards[i].rotation = lerp(shards[i].rotation, 0.4 * sign(shards_vel[i].x), 0.1)
		shards[i].position += shards_vel[i]
		shards_vel[i].x *= 0.9
		shards_vel[i].y += 0.5

func fight_broken():
	active_falling_shards.append(0)
	active_falling_shards.append(1)
	shards_vel[0] = Vector2(-5, -10)
	shards_vel[1] = Vector2(5, -10)
	shards_shake[0] = false
	shards_shake[1] = false

func act_broken():
	active_falling_shards.append(2)
	active_falling_shards.append(3)
	shards_vel[2] = Vector2(-5, -10)
	shards_vel[3] = Vector2(5, -10)
	shards_shake[2] = false
	shards_shake[3] = false

func item_broken():
	active_falling_shards.append(4)
	active_falling_shards.append(5)
	shards_vel[4] = Vector2(-5, -10)
	shards_vel[5] = Vector2(5, -10)
	shards_shake[4] = false
	shards_shake[5] = false

func on_buttons_destroy():
	$gui/main_buttons/fight.self_modulate.a = 0
	$gui/main_buttons/act.self_modulate.a = 0
	$gui/main_buttons/item.self_modulate.a = 0
	for i in len(shards_shake):
		shards_shake[i] = true
	$Periodic.add_method_oneshot(self, "fight_broken", [], 1)
	$Periodic.add_method_oneshot(self, "act_broken", [], 2)
	$Periodic.add_method_oneshot(self, "item_broken", [], 3)

func process_shard_shake():
	for i in len(shards_shake):
		if shards_shake[i]:
			shards[i].position.x = shards_original_pos[i].x + rand_range(-2, 2)
			shards[i].position.y = shards_original_pos[i].y + rand_range(-2, 2)



var attacks = [
	{
		"attack": preload("res://attacks/super_attack/sattack1/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack1/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack2/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack2/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack3/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack3/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack4/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack4/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack5/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack5/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack6/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack6/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack7/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack7/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack8/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack8/props.tres")
	},
	{
		"attack": preload("res://attacks/super_attack/sattack9/attack.tscn"),
		"props":  preload("res://attacks/super_attack/sattack9/props.tres")
	},
]
var current_attack_id = -1

func next_attack():
	current_attack_id+=1
	if current_attack_id >= len(attacks):
		return
	var attack:Node = attacks[current_attack_id]["attack"].instance()
	var props = attacks[current_attack_id]["props"]
	attack.set_difficulty(props, props, 0)
	$battle_framework.start_attack(attack)


func _on_battle_framework_attack_ended(attack):
	next_attack()


func _on_player_hp_changed(new_hp):
	$gui/TextureProgress.value = new_hp
	$gui/hp.text = str(new_hp) + "/20"


func _on_battle_framework_attack_custom_event(type, data):
	if type == "spawn_player":
		$player.position = data
	if type == "buttons_destroyed":
		on_buttons_destroy()
	
