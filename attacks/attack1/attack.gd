extends Attack

export var attack_duration:=10.5
export var attack_interval:float
export var projectile_count:int
export var projectile_velocity:float
export var attack_delay_after_alert:float

var alert_poses = []
var alert_sizes = []
var projectile_positions = []
var projectile_velocities = []
var last_side = 0

func start():
	spawn_healing_bullet()
	$Timer.start(attack_duration)
	$destroy.start(attack_duration+4)
	
	
	projectile_positions.append(Vector2(640+60, box_pos_y - box_size_y/4))
	projectile_positions.append(Vector2(box_pos_x + box_size_x/4, -60))
	projectile_positions.append(Vector2(-60, box_pos_y + box_size_y/4))
	projectile_positions.append(Vector2(box_pos_x - box_size_x/4, 480+60))
	
	projectile_velocities.append(Vector2(-projectile_velocity, 0))
	projectile_velocities.append(Vector2(0, projectile_velocity))
	projectile_velocities.append(Vector2(projectile_velocity, 0))
	projectile_velocities.append(Vector2(0, -projectile_velocity))
	
	alert_poses.append(Vector2(box_pos_x, box_pos_y-box_size_y/4))
	alert_poses.append(Vector2(box_pos_x+box_size_x/4, box_pos_y))
	alert_poses.append(Vector2(box_pos_x, box_pos_y+box_size_y/4))
	alert_poses.append(Vector2(box_pos_x-box_size_x/4, box_pos_y))
	
	alert_sizes.append(Vector2(box_size_x, box_size_y/2) - Vector2(10,10))
	alert_sizes.append(Vector2(box_size_x/2, box_size_y) - Vector2(10,10))
	alert_sizes.append(Vector2(box_size_x, box_size_y/2) - Vector2(10,10))
	alert_sizes.append(Vector2(box_size_x/2, box_size_y) - Vector2(10,10))
	
	$Periodic.add_method(self, "spawn_attack", [], attack_interval, 0, attack_duration-2)

func spawn_projectiles(side):
	for i in projectile_count:
		var new_proj = preload("res://attacks/super_attack/sattack3/projectile.tscn").instance()
		new_proj.position = projectile_positions[side]
		new_proj.position.x += rand_range(-alert_sizes[side].x/2, alert_sizes[side].x/2)
		new_proj.position.y += rand_range(-alert_sizes[side].y/2, alert_sizes[side].y/2)
		new_proj.vel = projectile_velocities[side]
		add_child(new_proj)

func _on_Timer_timeout():
	framework.stop_attack_softly()


func _on_destroy_timeout():
	queue_free()


func spawn_attack():
	var side = 0
	while true:
		side = randi()%4
		if side != last_side:
			break
	last_side = side
	
	var new_alert = preload("res://attacks/alert.tscn").instance()
	add_child(new_alert)
	if side == 0 or side == 2:
		new_alert.scale_exclamation_mark(Vector2(1, 0.5), Vector2(0, 12))
	new_alert.init_by_center(alert_poses[side], alert_sizes[side], attack_delay_after_alert)
	$Periodic.add_method_oneshot(self, "spawn_projectiles", [side], attack_delay_after_alert)
