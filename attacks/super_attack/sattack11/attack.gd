extends Attack

export var attack_duration:=10.5
export var attack_count:int
export var flash_interval:float
export var flash_delay:float
export var attacks_interval_start:float
export var attacks_interval_finish:float

var attacks = []
onready var last_flash = $eye_flash_left
var asgore_hflip = false
var attacks_interval
var attacks_passed = 0

func start():
	attacks_interval = attacks_interval_start
	spawn_healing_bullet()
	$Timer.start(attack_duration)
	$destroy.start(attack_duration+1)
	
	for i in attack_count:
		attacks.append(randi()%2)
	
	GlobalGeneral.camera_flash(5, 0, 1, Color.white)
	framework.trigger_custom_event("change_asgore_sprite", "shadow")
	
	for i in attack_count:
		$Periodic.add_method_oneshot(self, "flash", [i], flash_delay + i * flash_interval)
		
	$Periodic.add_method_oneshot(self, "attack", [], flash_delay + (attack_count-1) * flash_interval + attacks_interval + 0 * attacks_interval)

func flash(id):
	if last_flash == $eye_flash_left:
		last_flash = $eye_flash_right
	else:
		last_flash = $eye_flash_left
	
	if attacks[id] == 0:
		last_flash.modulate = Color("00FDF8")
	else:
		last_flash.modulate = Color("FFA23D")
	
	last_flash.play("default")
	last_flash.frame = 0

func attack():
	if attacks.empty():
		return
	var attack = attacks.pop_back()
	if attack == 0:
		framework.trigger_custom_event("change_asgore_sprite", "attack_blue")
	else:
		framework.trigger_custom_event("change_asgore_sprite", "attack_orange")
	
	$Periodic.add_method_oneshot(self, "spawn_projectile", [attack+1], 0.1)
	
	framework.trigger_custom_event("asgore_hflip", not asgore_hflip)
	asgore_hflip = not asgore_hflip
	
	if attacks_passed > attack_count/2:
		attacks_interval = lerp(attacks_interval, attacks_interval_finish, 0.1)
	
	
	$Periodic.add_method_oneshot(self, "attack", [], attacks_interval)
	attacks_passed+=1

func spawn_projectile(type:int):
	var new_proj = preload("res://attacks/attack9/projectile.tscn").instance()
	new_proj.type = type
	add_child(new_proj)

func _on_Timer_timeout():
	framework.stop_attack_softly()
	#framework.trigger_custom_event("change_asgore_sprite", "default")
	#framework.trigger_custom_event("asgore_hflip", false)



func _on_destroy_timeout():
	queue_free()
