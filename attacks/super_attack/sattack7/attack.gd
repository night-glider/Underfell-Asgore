extends Attack

const projectile = preload("res://attacks/attack3/projectile.tscn")

export var attack_duration:float
export var projectile_count:int
export var rotation_speed_min:float
export var rotation_speed_max:float
export var rotation_speed_drag:float
export var linear_speed:float
export var spawn_radius:int
export var spawn_interval:float
export var spawn_end_timing:float

func start():
	$Timer.start(attack_duration)
	$healing.start(attack_duration-4)
	$Periodic.add_method(self, "spawn_circle", [], spawn_interval, 0, spawn_end_timing)

func spawn_circle():
	create_projectiles( randi()%2 + 1 )

func create_projectiles(type:int):
	var color = Color.white
	if type == 1:
		color = Color("00FDF8")
	if type == 2:
		color = Color("FFA23D")
	
	var n = randf() * PI
	var rotation_speed = rand_range(rotation_speed_min, rotation_speed_max) * pow(-1, randi()%2 + 1)
	for i in projectile_count:
		var new_proj = projectile.instance()
		if i > projectile_count * 0.35:
			color = Color.white
			type = 0
		new_proj.init(
			type,
			color,
			Vector2(box_pos_x, box_pos_y), 
			n, 
			rotation_speed, 
			spawn_radius, 
			linear_speed,
			rotation_speed_drag)
		n+=2*PI/projectile_count
		add_child(new_proj)
	

func _on_Timer_timeout():
	framework.stop_attack_softly()


func _on_healing_timeout():
	spawn_healing_bullet()
