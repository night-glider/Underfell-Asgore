extends Node

func change_bus_volume(bus_name:String, volume:float):
	if volume == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear2db(volume))

func play_sound(sound:AudioStream):
	var audio_player := AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = "sound"
	audio_player.stream = sound
	audio_player.connect("finished", self, "_sound_finished", [audio_player])
	audio_player.play()

func play_music(music:AudioStream):
	var audio_player := AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = "music"
	audio_player.stream = music
	audio_player.connect("finished", self, "_sound_finished", [audio_player])
	audio_player.play()

func stop_all_sounds():
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.queue_free()

func _sound_finished(audio_player):
	audio_player.queue_free()
