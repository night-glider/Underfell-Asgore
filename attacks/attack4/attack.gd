extends Attack

const projectile = preload("res://attacks/attack4/projectile.tscn")

export var attack_duration:float
export var projectile_speed:float
export var spawn_timing:float

func start():
	$Timer.start(attack_duration)
	$healing.start(attack_duration-4)
	player.mode_green()
	
	$Periodic.add_method(self, "spawn_projectile", [], spawn_timing)

func spawn_projectile():
	var angle = 0.5 * PI * (randi() % 4)
	var velocity = Vector2.RIGHT.rotated(angle) * projectile_speed
	
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile.position = Vector2(box_pos_x, box_pos_y) - velocity.normalized() * 330
	new_projectile.init(velocity)

func _on_Timer_timeout():
	player.mode_normal()
	framework.stop_attack()


func _on_healing_timeout():
	spawn_healing_bullet()
