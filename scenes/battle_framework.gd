extends Control

onready var box:ReferenceRect = $box
onready var box_tween := $box/tween

export var default_box_tween_speed := 1.0
export var default_box_pos := Vector2(320,320)
export var default_box_size := Vector2(570,136)

signal attack_ended(attack)
signal attack_started(attack)

var player:Node2D = null
var active := false
var current_attack:Attack = null

func _ready():
	move_box(Vector2(320, 320), Vector2(570,136), 0)

func init(player):
	self.player = player

func move_box(pos: Vector2, size: Vector2, time: float = -1):
	if time < 0:
		time = default_box_tween_speed
	box_tween.stop_all()
	box_tween.interpolate_property(box, "rect_global_position", box.rect_global_position, pos - size / 2, time)
	box_tween.interpolate_property(box, "rect_size", box.rect_size, size, time)
	box_tween.start()

func start_attack(attack:Attack):
	current_attack = attack
	active = true
	add_child(current_attack)
	current_attack.init(self, player)
	current_attack.start()
	move_box(
		Vector2(current_attack.box_pos_y,attack.box_pos_x),
		Vector2(current_attack.box_size_x, attack.box_size_y),
		default_box_tween_speed)
	player.global_position.x = current_attack.player_spawn_x
	player.global_position.y = current_attack.player_spawn_y
	
	emit_signal("attack_started", current_attack)

func stop_attack():
	active = false
	if is_instance_valid(current_attack):
		current_attack.destroy()
	move_box(default_box_pos, default_box_size, default_box_tween_speed)
	
	emit_signal("attack_ended", current_attack)

func _process(delta):
	if not active:
		return
	
	if player == null:
		return
	
	_force_player_in_box()

func _force_player_in_box():
	player.position.x = clamp(player.position.x, box.rect_position.x+10, box.rect_position.x + box.rect_size.x-10)
	player.position.y = clamp(player.position.y, box.rect_position.y+10, box.rect_position.y + box.rect_size.y-10)
	
