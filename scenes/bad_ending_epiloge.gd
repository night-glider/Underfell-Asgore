tool
extends Control

var test = 0


func _ready():
	$AnimationPlayer.play("start")
	var music_player:AudioStreamPlayer = GlobalAudio.play_music( preload("res://audio/serenity.mp3") )
	music_player.volume_db = -80
	$Tween.interpolate_property(music_player, "volume_db", -80, 0, 4)
	$Tween.start()

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

func turn_on_face_sprite():
	$dialogue_box/DialogueLabel.margin_left = 0

func turn_off_face_sprite():
	$dialogue_box/DialogueLabel.margin_left = -100
	$dialogue_box/faces.play("empty")

func _on_DialogueLabel_dialogue_custom_event(data):
	if data == "turn_on_faces":
		turn_on_face_sprite()
		return
	if data == "turn_off_faces":
		turn_off_face_sprite()
		return
	if data == "fade_out":
		$AnimationPlayer.play("fade_out")
		return
	
	$dialogue_box/faces.play(data)

func _on_DialogueLabel_dialogue_ended():
	$dialogue_box.visible = false
	$AnimationPlayer.play("fade_in")

func to_credits():
	get_tree().change_scene("res://scenes/credits.tscn")
