extends Node2D
tool

var n = 0

func _process(delta):
	update()

func _draw():
	var height = 15 + sin(n) * 10
	var col = Color("FF6F47")
	for i in 16:
		draw_rect(
			Rect2(0, 480-i*height - height, 640, height),
			col
		)
		
		col.a *= 0.7
	
	n+=0.04
