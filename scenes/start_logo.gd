extends Control

var z_n = 0

func _process(delta):
	$press_z.modulate.a = 0.65 * sin(z_n)
	z_n += 0.05
	
	if Input.is_action_just_pressed("interact"):
		Input.action_release("interact")
		get_tree().change_scene("res://scenes/main_menu.tscn")
