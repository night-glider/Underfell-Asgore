extends Control

var slide_active:TextureRect

func _process(delta):
	if slide_active != null:
		slide_active.rect_position = lerp(slide_active.rect_position, Vector2.ZERO, 0.01)

func _ready():
	slide_active = $slide1
	$Tween.interpolate_property($slide1, "modulate", $slide1.modulate, Color.white, 1)
	$Tween.start()
	$slide1/dial.start_dialogue()
	$slide1/dial.player_controlled = true


func _on_dial1_dialogue_ended():
	$Tween.interpolate_property($slide1, "modulate", $slide1.modulate, Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($slide2, "modulate", $slide2.modulate, Color.white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "change_slide_active", [$slide2], 1)


func _on_dial2_dialogue_ended():
	$Tween.interpolate_property($slide2, "modulate", $slide2.modulate, Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($slide3, "modulate", $slide3.modulate, Color.white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "change_slide_active", [$slide3], 1)


func _on_dial3_dialogue_ended():
	$Tween.interpolate_property($slide3, "modulate", $slide3.modulate, Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($slide4, "modulate", $slide4.modulate, Color.white, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "change_slide_active", [$slide4], 1)


func _on_dial4_dialogue_ended():
	#$Tween.interpolate_property($slide4, "modulate", $slide4.modulate, Color(1,1,1,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($ColorRect2, "color", Color(1,1,1,0), Color.white, 3)
	$Tween.start()
	$Periodic.add_method_oneshot(self, "slides_ended", [], 3)

func slides_ended():
	get_tree().change_scene("res://scenes/fight_phase_3_after_slides.tscn")

func change_slide_active(new_slide:TextureRect):
	slide_active = new_slide
	new_slide.get_node("dial").player_controlled = true
	new_slide.get_node("dial").start_dialogue()
