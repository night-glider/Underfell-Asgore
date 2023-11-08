extends Attack

export var attack_duration:=10.5
export var projectile_count:int
export var projectile_spacing:int
export var projectile_speed:float
export var projectile_sin_spd:float
export var projectile_amplitude:float
export var projectile_detonation_y:int


func start():
	spawn_healing_bullet()
	$Timer.start(attack_duration)
	
	var n = 0
	for i in projectile_count:
		var new_proj_left = preload("res://attacks/super_attack/sattack8/projectile.tscn").instance()
		new_proj_left.init(box_pos_x - box_size_x/4, 480 + i * projectile_spacing, 
		n, projectile_sin_spd, projectile_amplitude, projectile_speed, projectile_detonation_y)
		new_proj_left.modulate = Color("00FDF8")
		new_proj_left.type = 1
		
		var new_proj_right = preload("res://attacks/super_attack/sattack8/projectile.tscn").instance()
		new_proj_right.init(box_pos_x + box_size_x/4, 480 + i * projectile_spacing, 
		n, projectile_sin_spd, projectile_amplitude, projectile_speed, projectile_detonation_y)
		new_proj_right.modulate = Color("FFA23D")
		new_proj_right.type = 2
		
		add_child(new_proj_left)
		add_child(new_proj_right)
		
		n+=2*PI/projectile_count
	
	n = PI
	for i in projectile_count:
		var new_proj_left = preload("res://attacks/super_attack/sattack8/projectile.tscn").instance()
		new_proj_left.init(box_pos_x - box_size_x/4, 480 + i * projectile_spacing, 
		n, projectile_sin_spd, projectile_amplitude, projectile_speed, projectile_detonation_y)
		new_proj_left.modulate = Color("00FDF8")
		new_proj_left.type = 1
		
		var new_proj_right = preload("res://attacks/super_attack/sattack8/projectile.tscn").instance()
		new_proj_right.init(box_pos_x + box_size_x/4, 480 + i * projectile_spacing, 
		n, projectile_sin_spd, projectile_amplitude, projectile_speed, projectile_detonation_y)
		new_proj_right.modulate = Color("FFA23D")
		new_proj_right.type = 2
		
		add_child(new_proj_left)
		add_child(new_proj_right)
		
		n+=2*PI/projectile_count

func _on_Timer_timeout():
	framework.stop_attack_softly()
