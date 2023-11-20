tool
extends Node2D

export var dialogue = [
	"ENDING_OVERWORLD_DIAL1",
	"ENDING_OVERWORLD_DIAL2",
	"ENDING_OVERWORLD_DIAL3",
	"ENDING_OVERWORLD_DIAL4",
	"ENDING_OVERWORLD_DIAL5",
	"ENDING_OVERWORLD_DIAL6",
	"ENDING_OVERWORLD_DIAL7",
	"ENDING_OVERWORLD_DIAL8",
	"ENDING_OVERWORLD_DIAL9",
	"ENDING_OVERWORLD_DIAL10",
	"ENDING_OVERWORLD_DIAL11",
	"ENDING_OVERWORLD_DIAL12",
	"ENDING_OVERWORLD_DIAL13",
	"ENDING_OVERWORLD_DIAL14",
	"ENDING_OVERWORLD_DIAL15",
	"ENDING_OVERWORLD_DIAL16"
]

var test = 0

func _ready():
	$asgore.frame = 0
	$asgore.play("default")
	$dial_box/DialogueLabel.change_messages(dialogue)
	$Periodic.add_method_oneshot(self, "start_dialogue", [], 3)
	$Tween.interpolate_property($ColorRect, "color", Color.white, Color(1,1,1,0), 0.5)
	$Tween.start()

func start_dialogue():
	$dial_box.visible = true
	$dial_box/DialogueLabel.start_dialogue()
	$dial_box/DialogueLabel.player_controlled = true
	GlobalAudio.play_music(preload("res://audio/closure.mp3"))

func _process(delta):
	test+=0.01
	update()

func _draw():
	for i in range(310, 1, -2):
		var col = sin( (i/100.0) + test ) * 0.5 + 0.5
		draw_rect(
			Rect2(310-i, 100-i, 20+i*2, 80+i*2),
			Color(col, col, col),
			true
		)


func _on_DialogueLabel_dialogue_ended():
	$dial_box.visible = false
	$Tween.interpolate_property($ColorRect, "color", Color(1,1,1,0), Color.white, 3)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "cutscene_ended", [], 3)

func cutscene_ended():
	get_tree().change_scene("res://scenes/credits.tscn")

func _on_DialogueLabel_dialogue_custom_event(data):
	$dial_box/faces.play(data)
