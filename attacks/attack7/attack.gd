extends Attack

export var attack_duration:=10.5
export var projectile_speed:float
export var projectile_scale:float
export var projectile_spawn_delay:float
export var attacks_interval:float
export var alert_lifetime:float

var sides := []
onready var alert_size = Vector2(box_size_x-10, box_size_y-10) / 2

func start():
	$Timer.start(attack_duration)
	
	sides = [
		{
			"pos": Vector2(box_pos_x - box_size_x*0.25, box_pos_y - box_size_y*0.25),
			"vel": Vector2.RIGHT * projectile_speed,
			"proj_pos": Vector2(0, box_pos_y - box_size_y*0.25)
		},
		{
			"pos": Vector2(box_pos_x + box_size_x*0.25, box_pos_y - box_size_y*0.25),
			"vel": Vector2.DOWN * projectile_speed,
			"proj_pos": Vector2(box_pos_x + box_size_x*0.25, 0)
		},
		{
			"pos": Vector2(box_pos_x + box_size_x*0.25, box_pos_y + box_size_y*0.25),
			"vel": Vector2.LEFT * projectile_speed,
			"proj_pos": Vector2(640, box_pos_y + box_size_y*0.25)
		},
		{
			"pos": Vector2(box_pos_x - box_size_x*0.25, box_pos_y + box_size_y*0.25),
			"vel": Vector2.UP * projectile_speed,
			"proj_pos": Vector2(box_pos_x - box_size_x*0.25, 480)
		}
	]
	
	$Periodic.add_method(self, "spawn_attacks", [], attacks_interval)
	spawn_attacks()

func spawn_attacks():
	var side = sides[randi()%4]
	
	var new_alert = preload("res://attacks/alert.tscn").instance()
	add_child(new_alert)
	new_alert.init_by_center(side["pos"], alert_size, alert_lifetime)
	
	$Periodic.add_method_oneshot(self, "spawn_projectiles", [side], projectile_spawn_delay)

func spawn_projectiles(side):
	var new_proj = preload("res://attacks/attack7/projectile.tscn").instance()
	new_proj.position = side["proj_pos"]
	new_proj.scale = Vector2(projectile_scale, projectile_scale)
	new_proj.init(side["vel"])
	add_child(new_proj)

func _on_Timer_timeout():
	framework.stop_attack()
