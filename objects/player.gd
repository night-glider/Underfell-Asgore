extends Sprite
class_name Player

export var speed := 2.0
export var max_hp := 20
export var invincibility_duration := 1.0
export var can_control = false

onready var flash_timer = $flash
onready var invincibility_timer = $invincibility

signal hp_changed(new_hp)

var hp = max_hp
var invincible := false
var prev_pos = Vector2.ZERO

func _process(delta):
	prev_pos = position
	if not can_control:
		return
	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	position += input.normalized() * speed


func take_hit(damage):
	if hp - damage <= 0 and hp > 1:
		hp = 1
		emit_signal("hp_changed", hp)
		return
	hp-=damage
	hp = clamp(hp, 0, max_hp)
	
	emit_signal("hp_changed", hp)


func enable_invincibility():
	invincible = true
	flash_timer.start()
	invincibility_timer.start(invincibility_duration)
	

func _on_hitbox_area_entered(area):
	if invincible:
		return
	if area is Projectile:
		if area.type == 1 and prev_pos == position:
			return
		if area.type == 2 and prev_pos != position:
			return
		take_hit(area.damage)
		area.player_hitted()
		enable_invincibility()


func _on_invincibility_timeout():
	invincible = false
	modulate.a = 1
	flash_timer.stop()


func _on_flash_timeout():
	if modulate.a == 1:
		modulate.a = 0.5
	else:
		modulate.a = 1
