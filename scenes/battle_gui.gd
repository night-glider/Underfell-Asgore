extends Control

class_name BattleGui

enum states {
	MAIN_BUTTONS
	PLAYER_ATTACKS
	ACT_CHOICE
	ITEM_CHOICE
	DIALOGUE
	ENEMY_ATTACKS
}

signal act_pressed(option_id)
signal waiting_for_next_state(last_action, additional_args)
signal item_consumed(item)

export(Array, Resource) var healing_items = []
export(Array, Resource) var act_options = []

export(Theme) var enemy_dialogue_theme

onready var main_buttons = [
	$main_buttons/fight,
	$main_buttons/act,
	$main_buttons/item
]

var player:Player
var battle_framework:BattleFramework
var active:=false
var state = states.MAIN_BUTTONS

var current_main_option:int = 0
var current_item_option:= Vector2.ZERO
var current_act_option:= Vector2.ZERO


func init(player:Player, battle_framework:BattleFramework):
	self.player = player
	self.battle_framework = battle_framework
	player.connect("hp_changed", self, "hp_changed")
	
	for item in healing_items:
		var new_label = Label.new()
		new_label.text = item.short_name
		$main_buttons/item/GridContainer.add_child(new_label)
	$main_buttons/item/GridContainer.get_children()[0].size_flags_horizontal = SIZE_EXPAND
	
	for option in act_options:
		var new_label = Label.new()
		new_label.text = option.name
		new_label.size_flags_horizontal = SIZE_EXPAND
		$main_buttons/act/GridContainer.add_child(new_label)
	
	main_buttons[current_main_option].animation = "selected"
	hp_changed(player.hp)
	active = true
	to_main_buttons()

func _process(delta):
	if not active:
		return
	
	process_enemy_hp_bar()
	
	match state:
		states.MAIN_BUTTONS:
			process_main_buttons()
		states.ACT_CHOICE:
			process_act_choice()
		states.ITEM_CHOICE:
			process_item_choice()
		

func process_enemy_hp_bar():
	$main_buttons/fight/enemy_hp.value = lerp($main_buttons/fight/enemy_hp.value, 0, 0.1)

func process_main_buttons():
	var direction = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
	if direction != 0:
		main_buttons[current_main_option].animation = "default"
		current_main_option = clamp(current_main_option+direction, 0, 2)
		var current_option = main_buttons[current_main_option]
		current_option.animation = "selected"
		player.position = current_option.position + Vector2(18,20)
	
	if Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		if current_main_option == 0:
			fight_button_pressed()
		if current_main_option == 1:
			act_button_pressed()
		if current_main_option == 2:
			item_button_pressed()

func process_item_choice():
	if Input.is_action_just_pressed("left"):
		current_item_option.x = clamp(current_item_option.x - 1, 0, 1)
	if Input.is_action_just_pressed("right"):
		current_item_option.x = clamp(current_item_option.x + 1, 0, 1)
	if Input.is_action_just_pressed("up"):
		current_item_option.y = clamp(current_item_option.y - 1, 0, 3)
	if Input.is_action_just_pressed("down"):
		current_item_option.y = clamp(current_item_option.y + 1, 0, 3)
	
	var item_index = current_item_option.x + current_item_option.y * 2
	
	var item_node = $main_buttons/item/GridContainer.get_children()[item_index] as Label
	var item = healing_items[item_index] as HealItem
	
	player.position = item_node.rect_global_position + Vector2(-16, 16)
	
	if Input.is_action_just_pressed("interact") and item_node.text != "":
		Input.action_release("interact")
		item_node.text = ""
		item.consumed(player)
		var message = tr(item.description) + "\n"
		if player.hp >= 20:
			message += tr("ITEM_HEALED_MAX")
		else:
			message += tr("ITEM_HEALED").format([item.heal])
		$main_buttons/item/GridContainer.visible = false
		$main_buttons/item.animation = "default"
		hide_player()
		start_dialogue([message])
		emit_signal("item_consumed", item)
	
	if Input.is_action_just_pressed("cancel"):
		$main_buttons/item/GridContainer.visible = false
		to_main_buttons()

func process_act_choice():
	if Input.is_action_just_pressed("left"):
		current_act_option.x = clamp(current_act_option.x - 1, 0, 1)
	if Input.is_action_just_pressed("right"):
		current_act_option.x = clamp(current_act_option.x + 1, 0, 1)
	
	var index = current_act_option.x + current_act_option.y * 2
	
	var option_node = $main_buttons/act/GridContainer.get_children()[index] as Label
	var option = act_options[index] as ActOption
	
	player.position = option_node.rect_global_position + Vector2(-16, 16)
	
	if Input.is_action_just_pressed("interact"):
		Input.is_action_just_released("interact")
		$main_buttons/act/GridContainer.visible = false
		hide_player()
		emit_signal("act_pressed", option.option_id)
	
	if Input.is_action_just_pressed("cancel"):
		$main_buttons/act/GridContainer.visible = false
		to_main_buttons()

func fight_button_pressed():
	state = states.PLAYER_ATTACKS
	$main_buttons/fight/background.visible = true
	$main_buttons/fight/target_line.visible = true
	hide_player()
	var side = randi() % 2
	$main_buttons/fight/target_line.start_attack(side, 1000)

func act_button_pressed():
	$main_buttons/act/GridContainer.visible = true
	state = states.ACT_CHOICE

func item_button_pressed():
	$main_buttons/item/GridContainer.visible = true
	state = states.ITEM_CHOICE

func hide_player():
	player.position = Vector2(-100,-100)

func start_dialogue(dialogue:Array):
	state = states.DIALOGUE
	$dial.change_messages(dialogue)
	$dial.player_controlled = true
	$dial.visible = true
	$dial.start_dialogue()
	

func hp_changed(new_hp:int):
	$TextureProgress.value = new_hp
	$hp.text = str(new_hp) + "/" + str(player.max_hp)

func to_main_buttons():
	var current_option = main_buttons[current_main_option]
	current_option.animation = "selected"
	player.position = current_option.position + Vector2(18,20)
	state = states.MAIN_BUTTONS

func _on_DialogueLabel_dialogue_custom_event(data):
	if data == "enemy_dial":
		$dial.rect_position = Vector2(430,55)
		$dial.rect_size = Vector2(200, 90)
		$dial.theme = enemy_dialogue_theme
		$dial_cloud.visible = true
	if data == "box_dial":
		$dial.rect_position = Vector2(39,255)
		$dial.rect_size = Vector2(560, 130)
		$dial.theme = null
		$dial_cloud.visible = false

func _on_DialogueLabel_dialogue_ended():
	_on_DialogueLabel_dialogue_custom_event("box_dial")
	$dial.player_controlled = false
	$dial.visible = false
	ask_for_next_state(state, [])


func _on_target_line_attack_ended(damage):
	if damage > 0:
		$main_buttons/fight/player_attack.frame = 0
		$main_buttons/fight/player_attack.play("default")
		$main_buttons/fight/damage_label.text = str(damage)
		$Periodic.add_method_oneshot(self, "player_attack_ended", [], 0.5)
	else:
		player_attack_ended()
		$main_buttons/fight/damage_label.text = "MISS"

func player_attack_ended():
	$main_buttons/fight/AnimationPlayer.play("fade_out")
	$main_buttons/fight/target_line.fade_in = true
	$main_buttons/fight/enemy_hp_anim.play("damage_dealt")
	$Periodic.add_method_oneshot(self, "ask_for_next_state", [state, []], 0.5)
	#ask_for_next_state(state, [])

func enemy_attacks(attack:Attack):
	state = states.ENEMY_ATTACKS
	battle_framework.start_attack(attack)

func ask_for_next_state(last_action:int, additional_args:Array):
	emit_signal("waiting_for_next_state", last_action, additional_args)
