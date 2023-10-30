extends Attack

export var attack_duration:=10.5
export var big_projectile_spd:float = 2
export var small_projectile_r_spd:float = 3
export var small_projectile_n_spd:float = 0.01
export var spawn_interval:float = 1

func start():
	spawn_healing_bullet()
	$Timer.start(attack_duration)
	$destroy.start(attack_duration+3)
	
	$Periodic.add_method(self, "spawn_meteor", [], spawn_interval, 0, attack_duration-2)

func spawn_meteor():
	var new_proj = preload("projectile.tscn").instance()
	new_proj.position = Vector2(rand_range(320, 640), -10)
	var target = Vector2(rand_range(box_pos_x - box_size_x/2, box_pos_x + box_size_x/2), box_pos_y - box_size_y/2)
	new_proj.init(target, big_projectile_spd)
	add_child(new_proj)

func spawn_circle(position):
	var type = randi()%2+1
	var color:Color
	if type == 1:
		color = Color("00FDF8")
	if type == 2:
		color = Color("FFA23D")
	for i in 20:
		var new_proj:Projectile = preload("projectile_bo.tscn").instance()
		new_proj.init(position, small_projectile_r_spd, ((2*PI)/20)*i, small_projectile_n_spd)
		new_proj.type = type
		new_proj.modulate = color
		add_child(new_proj)

func _on_Timer_timeout():
	framework.stop_attack_softly()


func _on_destroy_timeout():
	queue_free()
