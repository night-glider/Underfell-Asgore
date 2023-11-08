extends Attack

export var attack_duration:=10.5
export var rain_acceleration:float
export var rain_angle:float
export var rain_projectile_count:int
export var yellow_projectile_speed:float
export var yellow_projectile_spawn_interval:float

var spawned_rain_projectiles = 0
var rain_accel

func start():
	spawn_healing_bullet()
	$Timer.start(attack_duration)
	$destroy.start(attack_duration+3)
	
	player.mode_green()
	rain_accel = Vector2(rain_acceleration, 0).rotated(deg2rad(rain_angle))
	$Periodic.add_method(self, "spawn_yellow", [], yellow_projectile_spawn_interval, 0, attack_duration)

func _process(delta):
	player.position = lerp(player.position, Vector2(player_spawn_x,player_spawn_y), 0.1)
	
	if spawned_rain_projectiles < rain_projectile_count:
		var new_proj = preload("res://attacks/super_attack/sattack4/projectile.tscn").instance()
		new_proj.init(rain_accel)
		new_proj.rotation_degrees = rain_angle
		new_proj.respawn()
		$rain_particles.add_child(new_proj)
		spawned_rain_projectiles+=1

func spawn_yellow():
	var side = randi()%2
	var new_proj = preload("res://attacks/super_attack/sattack4/projectile_yellow.tscn").instance()
	if side == 0:
		new_proj.position = Vector2(650, box_pos_y)
		new_proj.init( Vector2(-yellow_projectile_speed, 0) )
	else:
		new_proj.position = Vector2(-10, box_pos_y)
		new_proj.init( Vector2(yellow_projectile_speed, 0) )
	add_child(new_proj)

func _on_Timer_timeout():
	for child in $rain_particles.get_children():
		child.can_respawn = false

func _on_destroy_timeout():
	framework.stop_attack_softly()
	player.mode_normal()
	queue_free()
