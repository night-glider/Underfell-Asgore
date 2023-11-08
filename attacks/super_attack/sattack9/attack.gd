extends Attack

export var attack_duration:=10.5
export var delay:=1.0
export var attack_interval:float
export var alert_time:float
export var projectile_count:=100
export var projectile_spd:=3.0
export var projectile_fade_spd:=0.1
export var projectile_damp:=0.9
export var same_place_probability = 0.5

var last_side = 0
var pos_y

func start():
	$Timer.start(attack_duration)
	$destroy.start(attack_duration + 3)
	
	pos_y = box_pos_y + box_size_y/2
	$Particles2D1.position = Vector2(box_pos_x-box_size_x/4, 480)
	$Particles2D2.position = Vector2(box_pos_x+box_size_x/4, 480)
	$Particles2D1.emitting = true
	$Particles2D2.emitting = true
	
	$Periodic.add_method(self, "attack", [], attack_interval, delay, attack_duration)

func _on_Timer_timeout():
	framework.stop_attack_softly()

func spawn_spike(pos):
	GlobalGeneral.camera_shake(10, 10)
	GlobalGeneral.camera_flash(5, 0, 1, Color.white)
	
	var projectile_interval = 480 / float(projectile_count)
	for i in projectile_count:
		var new_proj = preload("res://attacks/super_attack/sattack2/projectile.tscn").instance()
		new_proj.position.x = pos.x
		new_proj.position.y = projectile_interval * i
		new_proj.init(rand_range(-projectile_spd, projectile_spd), projectile_fade_spd, projectile_damp)
		add_child(new_proj)

func attack():
	if randf() > same_place_probability:
		if last_side == 0:
			last_side = 1
		else:
			last_side = 0
	
	var alert = preload("res://attacks/alert.tscn").instance()
	add_child(alert)
	var alert_pos
	
	if last_side == 0:
		$Periodic.add_method_oneshot(self, "spawn_spike", [$Particles2D1.position], alert_time)
		alert_pos = Vector2($Particles2D1.position.x, box_pos_y)
	if last_side == 1:
		$Periodic.add_method_oneshot(self, "spawn_spike", [$Particles2D2.position], alert_time)
		alert_pos = Vector2($Particles2D2.position.x, box_pos_y)
	
	alert.init_by_center(alert_pos, Vector2(box_size_x/2, box_size_y-16), alert_time )

func _on_destroy_timeout():
	queue_free()
