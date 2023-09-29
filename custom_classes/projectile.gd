extends Area2D
class_name Projectile

export var damage:int = 5

func player_hitted():
	queue_free()
