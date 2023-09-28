extends Sprite

export var speed = 3.0

func _process(delta):
	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	position += input.normalized() * speed
