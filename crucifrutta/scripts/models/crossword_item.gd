extends CommonModels

class_name CrosswordItem

enum DIRECTION {LEFT_TO_RIGHT, UP_TO_DOWN}

var _definition : StringName
var _answer : StringName
var _intersection : StringName
var _direction = DIRECTION

func _init(definition : StringName, answer : StringName, intersection : StringName, direction = DIRECTION.LEFT_TO_RIGHT) -> void:
	super._set("self._definition", definition)
	super._set("self._answer", answer)
	super._set("self._intersection", intersection)
	super._set("_direction", direction)

func calculate_shift() -> Vector2i:
	var shift = self._answer.find(self._intersection)
	
	if _direction == DIRECTION.LEFT_TO_RIGHT:
		return Vector2i(shift, 0)
	return Vector2i(0, shift)

func _to_string() -> String:
	var text = ""
	var shift = calculate_shift()
	
	text += "Definition : " + self._definition
	text += "\nAnswer : " + self._answer
	text += "\nIntersection : " + self._intersection
	text += "\nDirection : " + self._direction
	text += "\nShift from center x : " + str(shift.x)
	text += "\nShift from center y : " + str(shift.y)
	
	return text
	
	
