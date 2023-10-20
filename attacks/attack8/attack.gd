extends Attack

const hand = preload("res://attacks/attack8/hand.tscn")

export var attack_duration:=10.0
export var attack_delay:=1.0
export var attacks_interval:=5.0
export var projectiles_throw_delay:=2.0
export var hands_speed:=0.01
export var hands_projectile_timing:=0.15
export var projectiles_acceleration:=0.02

var last_hand_side := randi()%4

func start():
	$destruction.start(attack_duration)
	$healing.start(attack_duration-4)
	$Periodic.add_method(self, "spawn_hands", [], attacks_interval, attack_delay, attack_duration-attacks_interval)

func increment_repeating():
	last_hand_side+=1
	if last_hand_side > 3:
		last_hand_side=0

func decrement_repeating():
	last_hand_side-=1
	if last_hand_side < 0:
		last_hand_side=3

func _on_destruction_timeout():
	framework.stop_attack()

func spawn_hands():
	spawn_arm_side(last_hand_side)
	if randf() < 0.5:
		increment_repeating()
	else:
		decrement_repeating()

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
	new_hand.player = player
	new_hand.proj_accel = projectiles_acceleration
	new_hand.proj_timing = projectiles_throw_delay


func _on_healing_timeout():
	spawn_healing_bullet()
