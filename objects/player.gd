extends Sprite
class_name Player

enum soul_modes {
	NORMAL
	GREEN
	PURPLE
}

export var speed := 2.0
export var max_hp := 20
export var invincibility_duration := 1.0
export var can_control = false
export var game_over_active := true

onready var flash_timer = $flash
onready var invincibility_timer = $invincibility
onready var camera = $player_camera

signal hp_changed(new_hp)

var hp = max_hp
var additional_damage = 0
var invincible := false
var prev_pos = Vector2.ZERO
var mode = soul_modes.GREEN
var shield_target_angle = 0
var purple_mode_string_controller:Object = null
var constant_speed := Vector2.ZERO

func _ready():
	remove_child(camera)
	get_parent().call_deferred("add_child", camera)
	camera.position = Vector2.ZERO
	
	mode_normal()

func _process(delta):
	prev_pos = position
	if not can_control:
		return
	
	match mode:
		soul_modes.NORMAL:
			process_normal_mode()
		soul_modes.GREEN:
			process_green_mode()
		soul_modes.PURPLE:
			process_purple_mode()
	
	position += constant_speed

func process_normal_mode():
	var input = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	position += input.normalized() * speed

func process_green_mode():
	if Input.is_action_just_pressed("left"):
		shield_target_angle = PI
	if Input.is_action_just_pressed("right"):
		shield_target_angle = 0
	if Input.is_action_just_pressed("up"):
		shield_target_angle = -PI/2
	if Input.is_action_just_pressed("down"):
		shield_target_angle = PI/2
	
	$shield.rotation = lerp_angle($shield.rotation, shield_target_angle, 0.5)

func process_purple_mode():
	if Input.is_action_pressed("left"):
		position.x -= speed
	if Input.is_action_pressed("right"):
		position.x += speed
	if Input.is_action_just_pressed("up"):
		purple_mode_string_controller.player_pressed_up()
	if Input.is_action_just_pressed("down"):
		purple_mode_string_controller.player_pressed_down()
	
	position.y = purple_mode_string_controller.get_player_y_pos()

func mode_normal():
	mode = soul_modes.NORMAL
	self_modulate = Color(1, 0, 0)
	$soul_background.modulate = self_modulate
	$shield.visible = false
	$shield_background.visible = false
	$shield/hitbox/CollisionShape2D.disabled = true
	$AnimationPlayer.play("mode_changed")

func mode_green():
	mode = soul_modes.GREEN
	self_modulate = Color("00C000")
	$soul_background.modulate = self_modulate
	$shield.visible = true
	$shield_background.visible = true
	$shield/hitbox/CollisionShape2D.disabled = false
	$AnimationPlayer.play("mode_changed")

func mode_purple(purple_mode_string_controller):
	mode = soul_modes.PURPLE
	self_modulate = Color("D535D9")
	$soul_background.modulate = self_modulate
	$shield.visible = false
	$shield_background.visible = false
	$shield/hitbox/CollisionShape2D.disabled = true
	self.purple_mode_string_controller = purple_mode_string_controller
	$AnimationPlayer.play("mode_changed")

func take_hit(damage):
	if damage > 0:
		damage += additional_damage
	if hp - damage <= 0 and hp > 1:
		hp = 1
		emit_signal("hp_changed", hp)
		return
	hp-=damage
	hp = clamp(hp, 0, max_hp)
	
	if hp == 0 and game_over_active:
		GlobalGeneral.player_game_over_pos = position
		get_tree().change_scene("res://scenes/game_over.tscn")
	
	if damage < 0:
		GlobalAudio.play_sound( preload("res://audio/heal.wav") )
	else:
		GlobalAudio.play_sound( preload("res://audio/player_hit.wav") )
	
	emit_signal("hp_changed", hp)


func enable_invincibility():
	invincible = true
	flash_timer.start()
	invincibility_timer.start(invincibility_duration)

func apply_constant_speed(speed):
	constant_speed = speed

func reset_constant_speed():
	constant_speed = Vector2.ZERO

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
		if(area.damage > 0):
			enable_invincibility()
			camera.shake(10,2)


func _on_invincibility_timeout():
	invincible = false
	modulate.a = 1
	flash_timer.stop()


func _on_flash_timeout():
	if modulate.a == 1:
		modulate.a = 0.5
	else:
		modulate.a = 1



func _on_shield_area_entered(area):
	if area is Projectile:
		area.queue_free()
		$shield.play("hit")
		$shield/Timer.start(0.1)
		GlobalAudio.play_sound(preload("res://audio/shield_hitted.wav"))


func _on_shield_timer_timeout():
	$shield.play("default")
