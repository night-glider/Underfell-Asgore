extends Attack

export var attack_duration:float
export var box_pos_final_x:int
export var box_pos_final_y:int
export var box_size_final_x:int
export var box_size_final_y:int
export var box_final_transition_time:float
export var box_transition_delay:float
export var strings_speed:float
export var strings_interval:int
export var projectile_speed:float
export var fire_amplitude:float
export var fire_speed:float
export var fire_fade_speed:float

onready var string_drawer = $string_drawer
var strings = []
var player_string_index = 0

class PurpleString:
	var pos:float
	var projectile:Projectile
	var projectile_n:float

func start():
	$Timer.start(attack_duration)
	$healing.start(attack_duration-4)
	var current_pos = box_pos_y - box_size_y/2 + strings_interval
	while true:
		spawn_projectile_snake(current_pos, rand_range(-PI, PI))
		
		current_pos += strings_interval
		if current_pos > box_pos_y + box_size_y/2:
			break
	
	$string_drawer.init(strings)
	
	GlobalGeneral.camera_flash(2, 0, 1, Color.white)
	player.mode_purple(self)
	
	strings[0].projectile.queue_free()
	
	$Periodic.add_method_oneshot(self, "start_box_transition", [], box_transition_delay)

func spawn_projectile_snake(current_pos, n):
	var new_string = PurpleString.new()
	new_string.pos = current_pos
	new_string.projectile = preload("res://attacks/attack6/projectile.tscn").instance()
	new_string.projectile_n = n
	strings.append(new_string)
	add_child(new_string.projectile)

func _process(delta):
	spawn_fire_projectile()
	
	var box_pos = framework.get_box_pos()
	var box_size = framework.get_box_size()
	$string_drawer.min_x = box_pos.x + 3
	$string_drawer.max_x = box_pos.x + box_size.x - 3
	
	
	for string in strings:
		string.pos += strings_speed
		
		if is_instance_valid(string.projectile):
			string.projectile_n += projectile_speed
			string.projectile.position.y = string.pos
			string.projectile.position.x = box_pos.x + box_size.x/2 + sin(string.projectile_n) * box_size.x/2
	
	if strings[-1].pos > box_pos.y + box_size.y-3:
		var last_string:PurpleString = strings.pop_back()
		last_string.pos = strings[0].pos - strings_interval
		strings.push_front(last_string)
		player_string_index = clamp(player_string_index+1, 0, len(strings)-1)
		
		if is_instance_valid(last_string.projectile):
			last_string.projectile.queue_free()
		last_string.projectile = preload("res://attacks/attack6/projectile.tscn").instance()
		last_string.projectile_n = rand_range(-PI, PI)
		add_child(last_string.projectile)

func spawn_fire_projectile():
	var box_pos = framework.get_box_pos()
	var box_size = framework.get_box_size()
	var new_projectile = preload("res://attacks/attack6/projectile_fire.tscn").instance()
	new_projectile.position = Vector2(rand_range(box_pos.x, box_pos.x+box_size.x), box_pos.y + box_size.y)
	new_projectile.init(fire_amplitude, fire_speed, fire_fade_speed)
	add_child(new_projectile)

func _on_Timer_timeout():
	player.mode_normal()
	framework.stop_attack_softly()
	queue_free()

func get_player_y_pos():
	return strings[player_string_index].pos

func player_pressed_up():
	player_string_index = clamp(player_string_index-1, 0, len(strings)-1)

func player_pressed_down():
	player_string_index = clamp(player_string_index+1, 0, len(strings)-1)

func start_box_transition():
	framework.move_box(Vector2(box_pos_final_x,box_pos_final_y), Vector2(box_size_final_x, box_size_final_y), box_final_transition_time)

func _on_healing_timeout():
	spawn_healing_bullet()
