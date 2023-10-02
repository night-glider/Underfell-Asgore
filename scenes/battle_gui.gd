extends Control

enum states {
	MAIN_BUTTONS
	PLAYER_ATTACKS
	ACT_CHOICE
	ITEM_CHOICE
	DIALOGUE
}

export(Array, Resource) var healing_items = []

export(Theme) var enemy_dialogue_theme

onready var main_buttons = [
	$main_buttons/fight,
	$main_buttons/act,
	$main_buttons/item
]

var player:Player
var active:=false
var state = states.MAIN_BUTTONS

var current_main_option:int = 0 
var current_item_option:= Vector2.ZERO


func init(player:Player):
	self.player = player
	player.connect("hp_changed", self, "hp_changed")
	
	for item in healing_items:
		var new_label = Label.new()
		new_label.text = item.short_name
		$main_buttons/item/GridContainer.add_child(new_label)
	$main_buttons/item/GridContainer.get_children()[0].size_flags_horizontal = SIZE_EXPAND
	
	main_buttons[current_main_option].animation = "selected"
	hp_changed(player.hp)
	active = true

func _process(delta):
	if not active:
		return
	
	match state:
		states.MAIN_BUTTONS:
			process_main_buttons()
		states.ITEM_CHOICE:
			process_item_choice()
		

func process_main_buttons():
	var direction = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
	if direction != 0:
		main_buttons[current_main_option].animation = "default"
		current_main_option = clamp(current_main_option+direction, 0, 2)
		var current_option = main_buttons[current_main_option]
		current_option.animation = "selected"
		player.position = current_option.position + Vector2(18,20)
	
	if Input.is_action_just_pressed("interact"):
		if current_main_option == 0:
			OS.alert("fight picked")
		if current_main_option == 1:
			OS.alert("act_picked")
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
		item_node.text = ""
		item.consumed(player)
		var message = tr(item.description) + "\n"
		if player.hp >= 20:
			message += tr("ITEM_HEALED_MAX")
		else:
			message += tr("ITEM_HEALED").format([item.heal])
		$main_buttons/item/GridContainer.visible = false
		$main_buttons/item.animation = "default"
		player.position = Vector2(-100,-100)
		start_dialogue([message])
	
	if Input.is_action_just_pressed("cancel"):
		$main_buttons/item/GridContainer.visible = false
		to_main_buttons()

func item_button_pressed():
	$main_buttons/item/GridContainer.visible = true
	state = states.ITEM_CHOICE

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
	if data == "box_dial":
		$dial.rect_position = Vector2(39,255)
		$dial.rect_size = Vector2(560, 130)
		$dial.theme = null

func _on_DialogueLabel_dialogue_ended():
	$dial.player_controlled = false
	$dial.visible = false
	to_main_buttons()
