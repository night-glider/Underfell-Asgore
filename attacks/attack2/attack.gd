extends Attack

const hand = preload("res://attacks/attack2/hand.tscn")

export var attack_duration:=10.0
export var attack_delay:=1.0
export var attacks_interval:=5.0
export var projectiles_throw_delay:=2.0
export var hands_speed:=0.01
export var hands_projectile_timing:=0.15
export var projectiles_acceleration:=0.02

var hands_spawned := 0

func start():
	$destruction.start(attack_duration)
	$Periodic.add_method(self, "spawn_hands", [], attacks_interval, attack_delay, attack_duration-attacks_interval)

func _on_destruction_timeout():
	framework.stop_attack()

func spawn_hands():
	if hands_spawned % 2 == 0:
		spawn_arm_side(0)
		spawn_arm_side(1)
	else:
		spawn_arm_side(2)
		spawn_arm_side(3)
	$Periodic.add_method_oneshot(self, "throw_projectiles", [], projectiles_throw_delay)
	hands_spawned += 1

func spawn_arm_side(side:int):
	var new_hand = hand.instance()
	add_child(new_hand)
	match side:
		0:
			new_hand.init(Vector2(320,0), 230, 0.4 * PI, hands_speed, 0.2*PI, hands_projectile_timing)
		1:
			new_hand.init(Vector2(320,640), 230, -0.6 * PI, hands_speed, 0.2*PI, hands_projectile_timing)
			new_hand.flip_h = true
		2:
			new_hand.init(Vector2(0,320), 230, 1.9 * PI, hands_speed, 0.2*PI, hands_projectile_timing)
		3:
			new_hand.init(Vector2(640,320), 230, 0.9 * PI, hands_speed, 0.2*PI, hands_projectile_timing)
			new_hand.flip_h = true

func throw_projectiles():
	for node in get_children():
		if node is Projectile:
			if node.position.distance_squared_to(Vector2(320,320)) > 40000:
				node.queue_free()
			node.throw_at_target(player.global_position, projectiles_acceleration)
