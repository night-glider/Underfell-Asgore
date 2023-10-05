extends Area2D
class_name Projectile

enum damage_type {
	normal,
	blue,
	orange
}

export var damage:int = 5
#TODO
export var type:damage_type = damage_type.normal

func player_hitted():
	queue_free()
