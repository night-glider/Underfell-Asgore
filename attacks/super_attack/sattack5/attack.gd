extends Attack

export var attack_duration:=10.5
export var projectile_big_timing:float
export var projectile_big_spd:float
export var projectile_big_detonate_y_min:float
export var projectile_big_detonate_y_max:float
export var projectile_small_count:int
export var projectile_small_spd:float
export var projectile_small_spd_min:float
export var projecile_small_damping:float

func start():
	$Timer.start(attack_duration)
	$destroy.start(attack_duration+15)
	$Periodic.add_method(self, "spawn_proj", [], projectile_big_timing, 0, attack_duration)

func spawn_proj():
	var spawn_xs = [
		rand_range(100, box_pos_x-box_size_x-50),
		rand_range(box_pos_x+box_size_x+50, 640)]
	var new_proj = preload("res://attacks/attack5/projectile_big.tscn").instance()
	new_proj.position = Vector2(spawn_xs[randi()%2], 0)
	new_proj.init(
		projectile_big_spd,
		rand_range(projectile_big_detonate_y_min, projectile_big_detonate_y_max), 
		projecile_small_damping, 
		projectile_small_count,
		projectile_small_spd,
		projectile_small_spd_min)
	add_child(new_proj)

func _on_Timer_timeout():
	framework.stop_attack_softly()

func _on_destroy_timeout():
	queue_free()
