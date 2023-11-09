extends Node
class_name Attack

export var box_pos_x:=320
export var box_pos_y:=320
export var box_size_x:=570
export var box_size_y:=136
export var player_spawn_x:=320
export var player_spawn_y:=320

var start_box_transition_time:float = -1
var player:Player
var framework

func set_difficulty(easy:AttackProperties, hard:AttackProperties, difficulty:float):
	for prop in get_property_list():
		if prop["usage"] != 8199:
			continue
		
		var pr = prop["name"]
		set(pr, lerp(easy.properties[pr], hard.properties[pr], difficulty))

func init(framework, player):
	self.framework = framework
	self.player = player


func spawn_healing_bullet():
	var new_bullet = preload("res://attacks/flowey_projectile.tscn").instance()
	get_parent().add_child(new_bullet)
	new_bullet.position = Vector2(rand_range(0,640), 490)
	new_bullet.init(player)


func destroy():
	destroy_trash()
	queue_free()

#needed to prevent memory/object leaks
#abstract
func destroy_trash():
	pass

#abstract
func start():
	pass
