extends AnimatedSprite

var shake = false
var shake_center_x = 0
var shake_amp = 10
var shake_n = 0

func shake():
	shake_center_x = position.x
	shake = true

func _process(delta):
	if shake:
		position.x = shake_center_x + sin(shake_n) * shake_amp
		shake_n += 1
		shake_amp-=0.1
		if shake_amp < 0:
			shake = false
