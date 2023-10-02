extends Control


func _ready():
	$player.hp = 1
	$battle_gui.init($player)
	$battle_gui.start_dialogue([
		"TEST_DIAL1",
		"TEST_DIAL2"
	])
