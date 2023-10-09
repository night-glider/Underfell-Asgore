extends Node2D
tool

var n = 0

export var col = Color("DA96FF")

func _process(delta):
	update()

func _draw():
	var height = 15 + sin(n) * 10
	var col_a = col #Color("DA96FF") #"FF6F47" old color
	for i in 16:
		draw_rect(
			Rect2(0, 480-i*height - height, 640, height),
			col_a
		)
		
		col_a.a *= 0.7
	
	n+=0.04
