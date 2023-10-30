extends Node

signal camera_shake(duration, strength)
signal camera_flash(duration, fade_in, fade_out, color)

var player_game_over_pos := Vector2(320,320)

var temp_data := []

func camera_shake(duration, strength):
	emit_signal("camera_shake", duration, strength)

func camera_flash(duration, fade_in, fade_out, color):
	emit_signal("camera_flash", duration, fade_in, fade_out, color)
