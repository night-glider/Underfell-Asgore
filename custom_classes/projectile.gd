extends Area2D
class_name Projectile

export var damage:int = 5
export(int, "normal", "blue", "orange") var type = 0

func player_hitted():
	queue_free()
