extends Control

var attacks = {
	"[1] blank attack": {
		"attack": preload("res://attacks/attack1/attack.tscn"),
		"easy": preload("res://attacks/attack1/easy.tres"),
		"hard": preload("res://attacks/attack1/hard.tres")
		}
}
var current_attack:Attack = null

func _ready():
	$battle_framework.init($player)
	for attack in attacks.keys():
		$controls/attack.add_item(attack)
	
	_on_attack_item_selected(0)

func debug_properties_to_attack(grid:GridContainer, attack_props:AttackProperties):
	attack_props.properties.clear()
	var prop_name = ""
	for node in grid.get_children():
		if node is Label:
			prop_name = node.text
			continue
		if node is SpinBox:
			attack_props.properties[prop_name] = node.value
		if node is LineEdit:
			attack_props.properties[prop_name] = float(node.text)

func start_attack():
	var attack_data = attacks[$controls/attack.get_item_text($controls/attack.selected)]
	current_attack = attack_data["attack"].instance()
	debug_properties_to_attack($properties/easy/easy, attack_data["easy"])
	debug_properties_to_attack($properties/hard/hard, attack_data["hard"])
	current_attack.set_difficulty(attack_data["easy"], attack_data["hard"], $controls/difficulty.value)
	$battle_framework.start_attack(current_attack)

func stop_attack():
	$battle_framework.stop_attack()

func _on_start_pressed():
	if $controls/start.text == "Start":
		start_attack()
		return
	else:
		stop_attack()
		return


func _on_attack_item_selected(index):
	for node in $properties/easy/easy.get_children():
		node.queue_free()
	for node in $properties/hard/hard.get_children():
		node.queue_free()
	
	var attack:Attack = attacks[$controls/attack.get_item_text($controls/attack.selected)]["attack"].instance()
	var easy_props = attacks[$controls/attack.get_item_text($controls/attack.selected)]["easy"].properties
	var hard_props = attacks[$controls/attack.get_item_text($controls/attack.selected)]["hard"].properties
	for prop in attack.get_property_list():
		if prop["usage"] == 8199:
			var label = Label.new()
			label.text = prop["name"]
			label.size_flags_horizontal = SIZE_EXPAND_FILL
			label.autowrap = true
			label.rect_min_size.x = 100
			$properties/easy/easy.add_child(label)
			$properties/hard/hard.add_child(label.duplicate())
			
			var prop_editor_easy:Control = null
			var prop_editor_hard:Control = null
			if prop["type"] == 2:
				prop_editor_easy = SpinBox.new()
				prop_editor_easy.allow_greater = true
				prop_editor_easy.allow_lesser = true
				prop_editor_hard = prop_editor_easy.duplicate()
				prop_editor_easy.value = easy_props.get(prop["name"], 0)
				prop_editor_hard.value = hard_props.get(prop["name"], 0)
			else:
				prop_editor_easy = LineEdit.new()
				prop_editor_easy.size_flags_vertical = SIZE_SHRINK_CENTER
				prop_editor_hard = prop_editor_easy.duplicate()
				prop_editor_easy.text = str(easy_props.get(prop["name"], 0))
				prop_editor_hard.text = str(hard_props.get(prop["name"], 0))
			
			$properties/easy/easy.add_child(prop_editor_easy)
			$properties/hard/hard.add_child(prop_editor_hard)
			
			
	
	


func _on_battle_framework_attack_started(attack):
	$controls/start.text = "Stop"
	$properties.visible = false
	$controls/difficulty.editable = false
	$controls/copy.disabled = true
	$controls/attack.disabled = true


func _on_battle_framework_attack_ended(attack):
	$controls/start.text = "Start"
	$properties.visible = true
	$controls/difficulty.editable = true
	$controls/copy.disabled = false
	$controls/attack.disabled = false

func gather_props_from_grid(grid:GridContainer):
	var result = ""
	var prop_name = ""
	for node in grid.get_children():
		if node is Label:
			prop_name = node.text
			continue
		if node is SpinBox:
			result += "2 " + prop_name + " " + str(node.value) + "\n"
		if node is LineEdit:
			result += "3 " + prop_name + " " + node.text + "\n"
	
	return result

func _on_copy_pressed():
	var result = gather_props_from_grid($properties/easy/easy)
	OS.clipboard = result
	OS.alert("it's copied to ur clipboard!\nEASY properties\n" + result)
	result = gather_props_from_grid($properties/hard/hard)
	OS.clipboard = result
	OS.alert("it's copied to ur clipboard!\nHARD properties\n" + result)


func _on_player_hp_changed(new_hp):
	$hp.text = "hp: " + str(new_hp) + "/" + str($player.max_hp)
