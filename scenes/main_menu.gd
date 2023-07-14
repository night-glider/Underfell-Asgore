extends Control

const select_sound = preload("res://audio/select.wav")
const choice_sound = preload("res://audio/choice.wav")

onready var options = [
	$begin,
	$credits
]

func _ready():
	options[0].modulate = Color.yellow

func _on_menu_item_selected(pos):
	for option in options:
		option.modulate = Color.white
	options[pos.y].modulate = Color.yellow
	
	GlobalAudio.play_sound(select_sound)
	

func _on_menu_item_pressed(pos):
	GlobalAudio.play_sound(choice_sound)
	
	if pos.y == 0:
		get_tree().change_scene("res://scenes/difficulty_menu.tscn")
	if pos.y == 1:
		get_tree().change_scene("res://scenes/credits.tscn")
