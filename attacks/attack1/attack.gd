extends Attack

export var attack_duration:=10.5

func start():
	$Timer.start(attack_duration)
	
	for i in 25:
		var proj = preload("res://attacks/attack1/projectile.tscn").instance()
		proj.position.x = 320 + cos(i/25.0 * PI*2) * 50
		proj.position.y = 320 + sin(i/25.0 * PI*2) * 50
		add_child(proj)

func _on_Timer_timeout():
	framework.stop_attack()
