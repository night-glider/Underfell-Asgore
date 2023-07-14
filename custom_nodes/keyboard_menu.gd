extends Node
class_name KeyboardMenu

export var active := false
export var columns := 1
export var rows := 1

signal item_selected(pos)
signal item_pressed(pos)

var current_position = Vector2.ZERO

func _process(delta):
	if not active:
		return
	
	var pos_changed = false
	if Input.is_action_just_pressed("left"):
		current_position.x = clamp(current_position.x-1, 0, rows-1)
		pos_changed = true
	if Input.is_action_just_pressed("right"):
		current_position.x = clamp(current_position.x+1, 0, rows-1)
		pos_changed = true
	if Input.is_action_just_pressed("up"):
		current_position.y = clamp(current_position.y-1, 0, columns-1)
		pos_changed = true
	if Input.is_action_just_pressed("down"):
		current_position.y = clamp(current_position.y+1, 0, columns-1)
		pos_changed = true
	
	if pos_changed:
		emit_signal("item_selected", current_position)
	
	if Input.is_action_pressed("interact"):
		Input.action_release("interact")
		emit_signal("item_pressed", current_position)
	
	
