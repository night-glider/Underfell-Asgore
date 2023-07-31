extends Camera2D

class_name CameraExtended

var flash_duration := 15
var flash_fade_in_duration := 5
var flash_fade_out_duration := 5
var flash_time := 0
var flash_color := Color(1,1,1,0)
var flash_active := false

var shake_strength := 1.0
var shake_duration := 15
var shake_time := 0
var shake_active := false


func _init():
	z_index = VisualServer.CANVAS_ITEM_Z_MAX
	z_as_relative = false

func _process_flash():
	if not flash_active:
		return
	
	flash_time += 1
	if flash_time > flash_duration + flash_fade_in_duration + flash_fade_out_duration:
		flash_active = false
		flash_color = Color(0,0,0,0)
		return
	
	if flash_time <= flash_fade_in_duration:
		flash_color.a = (1.0/flash_fade_in_duration) * flash_time
		return
	
	if flash_time >= flash_fade_in_duration + flash_duration:
		flash_color.a = (1.0/flash_fade_out_duration) * (flash_duration + flash_fade_in_duration + flash_fade_out_duration - flash_time)
		return

func _process_shake():
	if not shake_active:
		return
	
	shake_time += 1
	
	if shake_time > shake_duration:
		shake_active = false
		offset = Vector2.ZERO
		return
	
	offset.x = rand_range(-shake_strength, shake_strength)
	offset.y = rand_range(-shake_strength, shake_strength)

func _process(delta):
	_process_flash()
	_process_shake()
	update()

func _draw():
	draw_rect(
		Rect2(-10,-10, 650,490),
		flash_color,
		true
	)

func flash(duration:int, fade_in:=0, fade_out:=1, color:=Color(1,1,1,1)):
	flash_active = true
	shake_time = 0
	flash_color = color
	flash_fade_in_duration = fade_in
	flash_fade_out_duration = fade_out
	flash_duration = duration

func shake(duration:int, strength:float):
	shake_active = true
	shake_time = 0
	shake_duration = duration
	shake_strength = strength
