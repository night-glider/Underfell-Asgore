extends Attack

export var attack_duration:=10.5
export var delay:=1.0
export var projectile_count:=100
export var projectile_spd:=3.0
export var projectile_fade_spd:=0.1
export var projectile_damp:=0.9
export var alert_size_x:=100

func start():
	$Timer.start(attack_duration)
	$destroy.start(attack_duration + 2)
	
	var pos_y = box_pos_y + box_size_y/2
	
	for elem in [$Particles2D, $Particles2D2, $Particles2D3]:
		elem.emitting = true
		var new_alert = preload("res://attacks/alert.tscn").instance()
		add_child(new_alert)
		new_alert.init_by_center( Vector2(elem.position.x, box_pos_y), Vector2(alert_size_x, box_size_y-16), 2 )
	
	$attack_timer.start(delay)

func _on_Timer_timeout():
	framework.stop_attack_softly()

func spawn_spike(pos):
	var projectile_interval = 480 / float(projectile_count)
	for i in projectile_count:
		var new_proj = preload("res://attacks/super_attack/sattack2/projectile.tscn").instance()
		new_proj.position.x = pos.x
		new_proj.position.y = projectile_interval * i
		new_proj.init(rand_range(-projectile_spd, projectile_spd), projectile_fade_spd, projectile_damp)
		add_child(new_proj)

func _on_attack_timer_timeout():
	spawn_spike($Particles2D.position)
	spawn_spike($Particles2D2.position)
	spawn_spike($Particles2D3.position)
	
	GlobalGeneral.camera_shake(10, 10)
	GlobalGeneral.camera_flash(5, 0, 1, Color.white)
	
	$Particles2D.emitting = false
	$Particles2D2.emitting = false
	$Particles2D3.emitting = false
	
	framework.trigger_custom_event("buttons_destroyed")
	$explosion.play()


func _on_destroy_timeout():
	queue_free()
