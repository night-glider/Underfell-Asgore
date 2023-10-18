extends Attack

export var attack_duration:float
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
	var current_pos = box_pos_y - box_size_y/2 + strings_interval
	while true:
		var new_string = PurpleString.new()
		new_string.pos = current_pos
		new_string.projectile = preload("res://attacks/attack6/projectile.tscn").instance()
		new_string.projectile_n = rand_range(-PI, PI)
		strings.append(new_string)
		add_child(new_string.projectile)
		
		current_pos += strings_interval
		if current_pos > box_pos_y + box_size_y/2:
			break
	
	$string_drawer.init(strings)
	
	player.mode_purple(self)
	
	strings[0].projectile.queue_free()

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
			string.projectile.position.x = box_pos_x + sin(string.projectile_n) * box_size_x/2
	
	if strings[-1].pos > box_pos_y + box_size_y/2-3:
		var last_string = strings.pop_back()
		last_string.pos = strings[0].pos - strings_interval
		strings.push_front(last_string)
		player_string_index = clamp(player_string_index+1, 0, len(strings)-1)
		
		if is_instance_valid(last_string.projectile):
			last_string.projectile.queue_free()
		last_string.projectile = preload("res://attacks/attack6/projectile.tscn").instance()
		last_string.projectile_n = rand_range(-PI, PI)
		add_child(last_string.projectile)

func spawn_fire_projectile():
	var new_projectile = preload("res://attacks/attack6/projectile_fire.tscn").instance()
	new_projectile.position = Vector2(rand_range(box_pos_x-box_size_x/2, box_pos_x+box_size_x/2), box_pos_y + box_size_y/2)
	new_projectile.init(fire_amplitude, fire_speed, fire_fade_speed)
	add_child(new_projectile)

func _on_Timer_timeout():
	player.mode_normal()
	framework.stop_attack()

func get_player_y_pos():
	return strings[player_string_index].pos

func player_pressed_up():
	player_string_index = clamp(player_string_index-1, 0, len(strings)-1)

func player_pressed_down():
	player_string_index = clamp(player_string_index+1, 0, len(strings)-1)
