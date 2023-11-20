extends Control

export var start_dial = [
	"PHASE3_ENDING_DIAL1",
	"PHASE3_ENDING_DIAL2",
	"PHASE3_ENDING_DIAL3",
	"PHASE3_ENDING_DIAL4",
	"PHASE3_ENDING_DIAL5",
	"PHASE3_ENDING_DIAL6",
	"PHASE3_ENDING_DIAL7",
	"PHASE3_ENDING_DIAL8",
	"PHASE3_ENDING_DIAL9",
]

export var mercy_dials = [
	"PHASE3_ENDING_MERCY1",
	"PHASE3_ENDING_MERCY2",
	"PHASE3_ENDING_MERCY3",
	"PHASE3_ENDING_MERCY4",
	"PHASE3_ENDING_MERCY5",
	"PHASE3_ENDING_MERCY6",
	"PHASE3_ENDING_MERCY7",
	"PHASE3_ENDING_MERCY8",
	"PHASE3_ENDING_MERCY9"
]

export var continue_dial = [
	"PHASE3_ENDING_DIAL_CONTINUE1",
	"PHASE3_ENDING_DIAL_CONTINUE2",
	"PHASE3_ENDING_DIAL_CONTINUE3",
	"PHASE3_ENDING_DIAL_CONTINUE4",
	"PHASE3_ENDING_DIAL_CONTINUE5",
	"PHASE3_ENDING_DIAL_CONTINUE6",
	"PHASE3_ENDING_DIAL_CONTINUE7",
	"PHASE3_ENDING_DIAL_CONTINUE8",
	"PHASE3_ENDING_DIAL_CONTINUE9",
	"PHASE3_ENDING_DIAL_CONTINUE10",
	"PHASE3_ENDING_DIAL_CONTINUE11",
	"PHASE3_ENDING_DIAL_CONTINUE12",
	"PHASE3_ENDING_DIAL_CONTINUE13",
	"PHASE3_ENDING_DIAL_CONTINUE14",
	"PHASE3_ENDING_DIAL_CONTINUE15",
	"PHASE3_ENDING_DIAL_CONTINUE16",
	"PHASE3_ENDING_DIAL_CONTINUE17",
	"PHASE3_ENDING_DIAL_CONTINUE18",
	"PHASE3_ENDING_DIAL_CONTINUE19",
	"PHASE3_ENDING_DIAL_CONTINUE20",
	"PHASE3_ENDING_DIAL_CONTINUE21",
	"PHASE3_ENDING_DIAL_CONTINUE22",
	"PHASE3_ENDING_DIAL_CONTINUE23",
	"PHASE3_ENDING_DIAL_CONTINUE24"
]

var stage = 0
var mercy_active = false
var remorse_fade_in = false
var remorse_fade_out = false
var remorse: AudioStreamPlayer

func _ready():
	$Periodic.add_method_oneshot(self, "start_dialogue", [], 2)

func start_dialogue():
	$gui/dial_cloud.visible = true
	$gui/dial.change_messages(start_dial)
	$gui/dial.start_dialogue()

func toggle_mercy(val):
	mercy_active = val
	if mercy_active:
		$rect/mercy.play("active")
		$soul.position = $rect/mercy.global_position + Vector2(-34, 0)
	else:
		$rect/mercy.play("default")
		$soul.position = Vector2(-100,-100)

func _process(delta):
	if remorse_fade_in:
		remorse.volume_db = lerp(remorse.volume_db, -80, 0.005)
	if remorse_fade_out:
		remorse.volume_db = lerp(remorse.volume_db, 0, 0.05)
	
	if mercy_active:
		if Input.is_action_just_pressed("interact"):
			GlobalAudio.play_sound(preload("res://audio/choice.wav"))
			var new_dial = mercy_dials.pop_back()
			$gui/dial_cloud.visible = true
			$gui/dial.change_messages([new_dial])
			$gui/dial.start_dialogue()
			toggle_mercy(false)
			if mercy_dials.empty():
				$AnimationPlayer.play("rect_fade_out")
				stage += 1


func _on_dial_dialogue_ended():
	$gui/dial_cloud.visible = false
	if stage == 0:
		$AnimationPlayer.play("rect_fade_in")
		remorse = GlobalAudio.play_music(preload("res://audio/remorse.mp3"))
	if stage == 1:
		toggle_mercy(true)
		return
	if stage == 2:
		$gui/dial_cloud.visible = true
		$gui/dial.change_messages(continue_dial)
		$gui/dial.start_dialogue()
	if stage == 3:
		get_tree().change_scene("res://scenes/ending_slides.tscn")
	
	stage+=1


func _on_dial_dialogue_custom_event(data):
	if data == "asgore_talks":
		$gui/dial_cloud_flowey.visible = false
		$gui/dial_cloud.visible = true
		$gui/dial.rect_position = Vector2(430, 55)
		$gui/dial.rect_size = Vector2(200, 90)
	if data == "flowey_talks":
		$gui/dial_cloud.visible = false
		$gui/dial_cloud_flowey.visible = true
		$gui/dial.rect_position = Vector2(40, 288)
		$gui/dial.rect_size = Vector2(200, 90)
	if data == "flowey_appears":
		remorse_fade_in = true
		$flowey.play("appears")
	if data == "flowey_sad":
		remorse_fade_in = false
		remorse_fade_out = true
		remorse.volume_db = -10
		$flowey.play("sad")
