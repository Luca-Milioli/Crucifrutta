extends Object 

class_name CommonModels

var a = 56

func _set(property: StringName, value: Variant) -> bool:
	for p in get_property_list():
		if String(property) == p["name"]:
			property = value
			return true
	return false

func _get(property: StringName) -> Variant:
	return self[property]
