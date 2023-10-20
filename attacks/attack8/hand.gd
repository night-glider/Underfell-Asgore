extends Sprite

const projectile = preload("res://attacks/attack8/projectile.tscn")

var center_pos:Vector2
var r:float
var n:float
var n_spd:float
var n_range:float
var projectile_time:float
var n_end:float
var n_destroy:float
var player:Player

var proj_accel
var proj_timing

func init(center_pos, r, n, n_spd, n_range, projectile_time):
	self.center_pos = center_pos
	self.r = r
	self.n = n
	self.n_spd = n_spd
	self.n_range = n_range
	$proj_timer.start(projectile_time)
	
	self.n_end = n + n_range
	self.n_destroy = self.n + PI

func _process(delta):
	position.x = center_pos.x + cos(n) * r
	position.y = center_pos.y + sin(n) * r
	n += n_spd
	
	if n > n_destroy:
		queue_free()

func _on_proj_timer_timeout():
	if n > n_end:
		$proj_timer.stop()
		return
	var new_proj = projectile.instance()
	new_proj.global_position = global_position
	get_parent().add_child(new_proj)
	new_proj.init(player, proj_accel, proj_timing)
