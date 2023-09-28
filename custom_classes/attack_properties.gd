extends Resource
class_name AttackProperties
tool

export(String, MULTILINE) var paste_properties_here := "" setget set_paste_properties_here
export(Dictionary) var properties := {}

func set_paste_properties_here(text:String):
	properties.clear()
	for line in text.split("\n", false):
		var var_components = line.split(" ")
		if len(var_components) < 3:
			return
		
		match var_components[0]:
			"2":
				properties[var_components[1]] = int(var_components[2])
			"3":
				properties[var_components[1]] = float(var_components[2])
	text = ""
	
