extends Sprite
var positions = []
var rotations = []

var rotation_spd = 4
var rotation_active = false

func enable_rotation():
	rotation_active = true

func _init():
	for i in 5:
		positions.append(position)
		rotations.append(rotation)

func _ready():
	$"1".modulate.a = 0.2
	$"2".modulate.a = 0.3
	$"3".modulate.a = 0.4

func _process(delta):
	if rotation_active:
		rotation_degrees += rotation_spd
		rotation_spd = lerp(rotation_spd, 0, 0.01)
		if rotation_degrees > 375:
			rotation_spd = 0.1
	
	positions.pop_front()
	rotations.pop_front()
	positions.append(position)
	rotations.append(rotation)
	$"1".global_position = positions[0]
	$"2".global_position = positions[1]
	$"3".global_position = positions[2]
	
	$"1".global_rotation = rotations[0]
	$"2".global_rotation = rotations[1]
	$"3".global_rotation = rotations[2]
