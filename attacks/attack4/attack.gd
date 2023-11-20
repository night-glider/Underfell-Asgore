extends Attack

const projectile = preload("res://attacks/attack4/projectile.tscn")
const projectile_yellow = preload("res://attacks/attack4/projectile_yellow.tscn")

export var attack_duration:float
export var projectile_speed:float
export var spawn_timing:float
export var yellow_projectile_chance:float
export var undyne_trap_timing:float

func start():
	$Timer.start(attack_duration)
	$healing.start(attack_duration-4)
	player.mode_green()
	
	$Periodic.add_method_oneshot(self, "spawn_projectile", [], spawn_timing)

func spawn_projectile():
	var angle = 0.5 * PI * (randi() % 4)
	var velocity = Vector2.RIGHT.rotated(angle) * projectile_speed
	
	var new_projectile:Projectile
	if randf() < yellow_projectile_chance and $Timer.time_left > undyne_trap_timing:
		new_projectile = projectile_yellow.instance()
		new_projectile.position = Vector2(box_pos_x, box_pos_y) - velocity.normalized() * 330
		if $Timer.time_left > undyne_trap_timing:
			$Periodic.add_method_oneshot(self, "spawn_projectile", [], spawn_timing + 0.5)
	else:
		new_projectile = projectile.instance()
		new_projectile.position = Vector2(box_pos_x, box_pos_y) - velocity.normalized() * 330
		if $Timer.time_left > undyne_trap_timing:
			$Periodic.add_method_oneshot(self, "spawn_projectile", [], spawn_timing)
	add_child(new_projectile)
	new_projectile.init(velocity)

func spawn_trap():
	player.mode_normal()
	for angle in [0, PI/2]:
		var velocity = Vector2.RIGHT.rotated(angle) * projectile_speed * 3
		
		var new_projectile:Projectile
		new_projectile = projectile.instance()
		new_projectile.position = Vector2(box_pos_x, box_pos_y) - velocity.normalized() * (330 + spawn_timing * 30)
		add_child(new_projectile)
		new_projectile.init(velocity)

func _on_Timer_timeout():
	if randf() > 0.75:
		stop()
	spawn_trap()
	$Periodic.add_method_oneshot(self, "stop", [], 1)

func stop():
	player.mode_normal()
	framework.stop_attack()

func _on_healing_timeout():
	spawn_healing_bullet()
