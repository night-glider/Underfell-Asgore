extends Node2D

var strings
var min_x = 0
var max_x = 0

var col = Color("D535D9")

func init(strings):
	self.strings = strings

func _draw():
	for string in strings:
		draw_line(Vector2(min_x, string.pos), Vector2(max_x, string.pos), col)

func _process(delta):
	update()
