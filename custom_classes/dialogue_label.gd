extends RichTextLabel
class_name DialogueLabel

export(Array, String) var messages := ["HELLO_WORLD"]
export var sound_bits := {
	"null": null,
	"asgore": preload("res://audio/asgore_talk.ogg"),
	"default": preload("res://audio/talk_default.wav")
}
export var silent_symbols := [",", ".", "-", " ", "[", "]"]
export var text_speed := 0.25
export var player_controlled = false

signal dialogue_started
signal message_next(index)
signal dialogue_ended
signal message_finished
signal dialogue_custom_event(data)

var active = false
var message_id = 0

var chars_to_display = 0.0
var tags = []
var delay_frames = 0
var audio_player = AudioStreamPlayer.new()

func _init():
	bbcode_enabled = true

func _ready():
	bbcode_text = ''
	add_child(audio_player)
	
	if messages.empty():
		push_error("no messages in DialogueLabel " + name)

func get_current_message()->String:
	return messages[message_id]

func stop_dialogue():
	bbcode_text = ""
	
	emit_signal("dialogue_ended")

func stop_dialogue_silently():
	bbcode_text = ""

func change_messages(new_array:Array):
	messages = new_array.duplicate()
	
	message_id = 0
	active = false

func start_dialogue():
	message_id = -1
	
	next_message()
	emit_signal("dialogue_started")

func next_message():
	message_id+=1
	visible_characters = 0
	percent_visible = 0
	
	if message_id >= messages.size():
		active = false
		emit_signal("dialogue_ended")
		return
	
	messages[message_id] = tr(messages[message_id])
	bbcode_text = _remove_custom_tags(messages[message_id])
	tags = _parse_custom_tags( messages[message_id] )
	tags.pop_front()
	active = true
	
	emit_signal("message_next", message_id)

func skip_message():
	percent_visible = 1

func _remove_custom_tags(string)->String:
	var result = ""
	var current_tag = ""
	for chr in string:
		if chr == "[":
			current_tag = "["
			continue
		if chr == "]":
			current_tag += "]"
			if "inst" in current_tag:
				current_tag = ""
				continue
			if "spd" in current_tag:
				current_tag = ""
				continue
			if "snd" in current_tag:
				current_tag = ""
				continue
			if "wait" in current_tag:
				current_tag = ""
				continue
			if "event" in current_tag:
				current_tag = ""
				continue
			
			result += current_tag
			current_tag = ""
			continue
		if current_tag != "":
			current_tag+=chr
			continue
		
		result += chr
		
	return result

func _parse_custom_tags(string)->Array:
	var result = [""]
	var inside_tag = false
	var current_pos = 0
	var inside_tag_name = false
	var inside_tag_value = false
	var current_tag = ""
	var current_tag_value = ""
	
	for chr in string:
		if inside_tag:
			if chr == "]":
				inside_tag = false
				if current_tag in ["inst", "spd", "snd", "wait", "event"]:
					result.append( {
						"name":current_tag, 
						"pos": current_pos,
						"value":current_tag_value} )
				
				current_tag = ""
				current_tag_value = ""
				continue
			if chr == " ":
				inside_tag_name = false
				if current_tag in ["inst", "spd", "snd", "wait", "event"]:
					inside_tag_value = true
				
				continue
			if inside_tag_name:
				current_tag+=chr
				continue
			if inside_tag_value:
				current_tag_value+=chr
				continue
			
			continue
		if chr == "[":
			inside_tag = true
			inside_tag_name = true
			continue
		
		result[0] += chr
		current_pos+=1
	
	return result
	

func _advance_text():
	if not active:
		return
		
	if delay_frames>0:
		delay_frames -=1
		return
		
	if percent_visible >= 1:
		active = false
		emit_signal("message_finished")
		return
	
	chars_to_display+=text_speed
	visible_characters+=floor(chars_to_display)
	visible_characters = clamp(visible_characters, 1, len(text))
	
	if floor(chars_to_display) >= 1:
		if visible_characters > 1:
			if not text[visible_characters-1] in silent_symbols:
					audio_player.play()
	chars_to_display-=floor(chars_to_display)
	
	
	if tags.empty():
		return
	
	if tags[0]["pos"] <= visible_characters:
		visible_characters = tags[0]["pos"]
		if tags[0]["name"] == "inst":
			visible_characters += int(tags[0]["value"])
		elif tags[0]["name"] == "spd":
			text_speed = float(tags[0]["value"])
		elif tags[0]["name"] == "snd":
			audio_player.stream = sound_bits.get(tags[0]["value"], null)
		elif  tags[0]["name"] == "wait":
			delay_frames = int(tags[0]["value"])
		elif  tags[0]["name"] == "event":
			emit_signal("dialogue_custom_event", tags[0]["value"])
		tags.pop_front()

func _process_player_control():
	if not player_controlled:
		return
	
	if message_id >= messages.size():
		return
	
	if Input.is_action_just_pressed("cancel"):
		skip_message()
	if Input.is_action_just_pressed("interact"):
		if percent_visible >= 1:
			next_message()

func _process(delta):
	_advance_text()
	_process_player_control()
