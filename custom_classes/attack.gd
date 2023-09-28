extends Node
class_name Attack

export var box_pos_x:=320
export var box_pos_y:=320
export var box_size_x:=570
export var box_size_y:=136
export var player_spawn_x:=320
export var player_spawn_y:=320

var player:Node2D = null
var framework:Node = null

func set_difficulty(easy:AttackProperties, hard:AttackProperties, difficulty:float):
	for prop in get_property_list():
		if prop["usage"] != 8199:
			continue
		
		var pr = prop["name"]
		set(pr, lerp(easy.properties[pr], hard.properties[pr], difficulty))

func init(framework, player):
	self.framework = framework
	self.player = player



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
