extends Resource
class_name HealItem

export var heal:int = 5
export var short_name:String = ""
export var description:String = ""

#default method when consumed
func consumed(player:Player):
	player.take_hit(-heal)
