extends Control

var programmer_role = "p"
var programmer = [
	"p",
	"pr",
	"pro",
	"prog",
	"progr",
	"progra",
	"program",
	"programe",
	"programer",
	"programe",
	"programm",
	"programme",
	"programmer",
	"programmer ",
	"programmer =",
	"programmer =)",
]
var programmer_caret_visible = true

func _ready():
	$AnimationPlayer.play("fade_out")
	$Periodic.add_method(self, "process_programmer_role_caret", [], 0.25)
	$Periodic.add_method_oneshot(self, "process_programmer_role", [], 14)

func _logo_sound():
	GlobalAudio.play_sound(preload("res://audio/logo.mp3"))

func roll_credits():
	$AnimationPlayer.play("roll")

func end_credits():
	GlobalAudio.stop_all_sounds()
	get_tree().change_scene("res://scenes/start_logo.tscn")

func process_programmer_role_caret():
	programmer_caret_visible = !programmer_caret_visible

func _process(delta):
	if programmer_caret_visible:
		$best2.text = programmer_role + "_"
	else:
		$best2.text = programmer_role

func process_programmer_role():
	if programmer.empty():
		return
	programmer_role = programmer.pop_front()
	if programmer_role == "programer":
		$Periodic.add_method_oneshot(self, "process_programmer_role", [], 0.5)
		return
	$Periodic.add_method_oneshot(self, "process_programmer_role", [], 0.1)
	
