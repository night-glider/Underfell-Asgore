extends ReferenceRect

class_name Alert

var flash_interval:=0.1

func _ready():
	$flash.start(flash_interval)

func init_by_corner(pos:Vector2, size:Vector2, time:float):
	rect_position = pos
	rect_size = size
	$destruction.start(time)

func init_by_center(pos:Vector2, size:Vector2, time:float):
	rect_position = pos - size/2
	rect_size = size
	$destruction.start(time)

func scale_exclamation_mark(scale, offset=Vector2.ZERO):
	$TextureRect.rect_scale = scale
	$TextureRect.rect_position += offset

func _on_flash_timeout():
	if modulate.a == 1:
		modulate.a = 0.5
	else:
		modulate.a = 1
	$AudioStreamPlayer.play()


func _on_destruction_timeout():
	queue_free()
