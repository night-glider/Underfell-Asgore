extends Projectile

var spd=0
var detonation_y=480
var damping=1
var proj_count=8
var proj_spd=2
var proj_spd_min

func init(spd, detonation_y, damping, proj_count, proj_spd, proj_spd_min):
	self.spd = spd
	self.detonation_y = detonation_y
	self.damping = damping
	self.proj_count = proj_count
	self.proj_spd = proj_spd
	self.proj_spd_min = proj_spd_min

func _process(delta):
	position.y += spd
	
	if position.y > detonation_y:
		detonate()
		queue_free()

func detonate():
	for i in proj_count:
		var new_proj = preload("res://attacks/attack5/projectile_small.tscn").instance()
		get_parent().add_child(new_proj)
		new_proj.position = position
		new_proj.init(Vector2.RIGHT.rotated((2.0*PI/proj_count)*i) * proj_spd, damping, proj_spd_min)
