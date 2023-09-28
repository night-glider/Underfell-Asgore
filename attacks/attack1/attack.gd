extends Attack

export var attack_duration:=10.5

func start():
	$Timer.start(attack_duration)

func _on_Timer_timeout():
	framework.stop_attack()
