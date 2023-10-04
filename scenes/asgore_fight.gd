extends Control

func _ready():
	$player.hp = 1
	$battle_gui.init($player)


func _on_battle_gui_act_pressed(option_id):
	if option_id == "check":
		$battle_gui.start_dialogue(["check pressed! no way.."])
	if option_id == "refuse":
		$battle_gui.start_dialogue(["refuse pressed!"])
