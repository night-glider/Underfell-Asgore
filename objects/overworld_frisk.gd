extends KinematicBody2D

onready var sprite = $AnimatedSprite

export var max_speed = 200
export var can_control = true

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if can_control:
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
	
	velocity = velocity.normalized() * max_speed
	
	var moved = move_and_slide(velocity)
	if moved.length_squared() > 0:
		sprite.playing = true
	else:
		sprite.playing = false
		sprite.frame = 0
	
	choose_animation()

func choose_animation():
	if velocity.y < 0:
		sprite.animation = "move_up"
		return
	if velocity.y > 0:
		sprite.animation = "move_down"
		return
	if velocity.x < 0:
		sprite.animation = "move_left"
		return
	if velocity.x > 0:
		sprite.animation = "move_right"
		return
