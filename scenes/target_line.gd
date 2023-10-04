extends AnimatedSprite

signal attack_ended(damage)

var end_position := 0
var spd := 0
var active := false
var max_damage := 100.0
var fade_in := false

func start_attack(side, max_damage):
	animation = "default"
	fade_in = false
	modulate.a = 0.99
	active = true
	if side == 0:
		position.x = 0
		end_position = 286+100
		spd = 4
	if side == 1:
		position.x = 570
		end_position = 286-100
		spd = -4

func _process(delta):
	if fade_in:
		modulate.a -= 0.033
	
	if not active:
		return
	
	position.x += spd
	if abs(position.x - end_position) < 50:
		fade_in = true
	
	if modulate.a <= 0:
		emit_signal("attack_ended", 0)
		active = false
		return
	
	if Input.is_action_just_pressed("interact") and modulate.a > 0.9:
		active = false
		animation = "selected"
		var distance = abs(position.x - 286)
		if distance < 10:
			emit_signal("attack_ended", max_damage)
			return
		var damage = clamp(max_damage - (max_damage / 100) * (distance / 2), 0, max_damage)
		emit_signal("attack_ended", damage)
		return
