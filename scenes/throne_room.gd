extends Node2D

onready var camera = $camera

func _ready():
	remove_child(camera)
	$frisk.add_child(camera)
	$gui.visible = false
	
	var timer = Timer.new()
	timer.connect("timeout", self, "at_long_last_play")
	timer.one_shot = true
	add_child(timer)
	timer.start(3)
	

func _on_trigger1_body_entered(body:Node):
	if body.name != "frisk":
		return
	
	$trigger1.queue_free()
	$frisk.can_control = false
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "global_position", Vector2(300,375), 1)
	
	$Periodic.add_method_oneshot(
		self, 
		"start_dialogue", 
		[["THRONE_ASGORE_DIALOGUE1",
		"THRONE_ASGORE_DIALOGUE2",
		"THRONE_ASGORE_DIALOGUE3",
		"THRONE_ASGORE_DIALOGUE4",
		"THRONE_ASGORE_DIALOGUE5",
		"THRONE_ASGORE_DIALOGUE6",
		"THRONE_ASGORE_DIALOGUE7",
		"THRONE_ASGORE_DIALOGUE8",
		"THRONE_ASGORE_DIALOGUE9",
		"THRONE_ASGORE_DIALOGUE10",
		"THRONE_ASGORE_DIALOGUE11",
		"THRONE_ASGORE_DIALOGUE12"]], 
		1)

func start_dialogue(messages:Array):
	$gui.visible = true
	$gui/Control/DialogueLabel.change_messages(messages)
	$gui/Control/DialogueLabel.start_dialogue()

func _on_dialogue_custom_event(data):
	if data == "asgore_stand_up":
		$gui.visible = false
		$asgore.play("stand_up")
		$Periodic.add_method_oneshot(self, "show_gui", [], 2.5)
	
	if data == "take_to_barrier":
		$gui/Control/DialogueLabel.player_controlled = false
		$AnimationPlayer.play("fade_in")
	
	if "face" in data:
		$gui/Control/faces.play(data)
	
func show_gui():
	$gui.visible = true

func next_room():
	get_tree().change_scene("res://scenes/throne_room2.tscn")

func at_long_last_play():
	$at_long_last.play()
