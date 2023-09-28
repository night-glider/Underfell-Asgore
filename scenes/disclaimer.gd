extends Control

var z_n = 0
export var active = false

func _ready():
	$AnimationPlayer.play("fade_out")
	print(get_property_list())

func _process(delta):
	if active:
		$press_z.modulate.a = 0.65 * sin(z_n)
		z_n += 0.05
	else:
		$press_z.modulate.a = lerp($press_z.modulate.a, 0, 0.1)
	
	if Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		$AnimationPlayer.play("fade_in")

func go_to_logo():
	get_tree().change_scene("res://scenes/start_logo.tscn")
