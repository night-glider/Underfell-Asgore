tool
extends Node2D

var test = 0

func _ready():
	$AnimationPlayer.play("battle_starts")

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


func _on_AnimationPlayer_animation_finished(anim_name):
	if not Engine.editor_hint:
		get_tree().change_scene("res://scenes/battle_intro.tscn")
