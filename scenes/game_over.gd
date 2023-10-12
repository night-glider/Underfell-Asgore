extends Control

var shake_amp = 0
var shake_active = true
var soul_position = GlobalGeneral.player_game_over_pos
var soul_to_asgore = false

func _ready():
	$soul.position = GlobalGeneral.player_game_over_pos
	$Particles2D.position = $soul.position
	$AnimationPlayer.play("fade_in_2")
	shake()
	
func _process(delta):
	$soul.position = soul_position + Vector2(rand_range(-shake_amp, shake_amp), rand_range(-shake_amp, shake_amp))
	shake_amp-=0.1
	shake_amp = clamp(shake_amp, 0, 10)
	
	if soul_to_asgore:
		soul_position = lerp(soul_position, Vector2(320,240), 0.1)
	
	process_choice_input()

func shake():
	shake_amp = 3
	$Periodic.add_method_oneshot(self, "shake", [], rand_range(1, 3))

func finish():
	get_tree().change_scene("res://scenes/asgore_fight.tscn")

func _on_DialogueLabel_dialogue_ended():
	$AnimationPlayer.play("continue_no_ending")

func start_asgore_dialogue():
	$DialogueLabel.player_controlled = true
	$DialogueLabel.start_dialogue()

func process_choice_input():
	if not $choice.visible:
		return
	if Input.is_action_just_pressed("left"):
		$choice/YES.modulate = Color.yellow
		$choice/NO.modulate = Color.white
	if Input.is_action_just_pressed("right"):
		$choice/NO.modulate = Color.yellow
		$choice/YES.modulate = Color.white
	
	if Input.is_action_just_pressed("interact"):
		if $choice/YES.modulate == Color.yellow:
			$soul.visible = false
			$Particles2D.emitting = true
			$choice.visible = false
			$AnimationPlayer.play("fade_out_2")
		
		if $choice/NO.modulate == Color.yellow:
			$choice.visible = false
			$AnimationPlayer.play("continue_no")


func _on_DialogueLabel_message_next(message_id):
	if message_id == 1:
		soul_to_asgore = true

func crash_game():
	get_tree().quit()
