extends Projectile

var player:Player
var angle:float
var spd:float = 1.5
var tracking:=true


func init(player:Player):
	self.player = player
	
	angle = position.angle_to_point(player.position)

func _process(delta):
	if position.distance_squared_to(player.position) < 5000:
		tracking = false
	if tracking:
		angle = move_toward(angle, position.angle_to_point(player.position), 0.01)
	position -= Vector2.RIGHT.rotated(angle) * spd


func _on_Timer_timeout():
	queue_free()
