extends Object 

class_name CommonModels

func _set(property: StringName, value: Variant) -> bool:
	if property in get_property_list():
		property = value
		return true
	return false

func _get(property: StringName) -> Variant:
	return property
