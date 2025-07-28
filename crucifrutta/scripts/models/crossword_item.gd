class_name CrosswordItem

enum DIRECTION { LEFT_TO_RIGHT, UP_TO_DOWN }

var _definition: String
var _answer: String
var _intersection: String
var _direction: DIRECTION


func _init(
	definition: String, answer: String, intersection: String, direction = DIRECTION.LEFT_TO_RIGHT
) -> void:
	set("_definition", definition)
	set("_answer", answer)
	set("_intersection", intersection)
	set("_direction", direction)


func calculate_shift() -> Vector2i:
	var shift = self._answer.find(self._intersection.to_upper())

	if _direction == DIRECTION.LEFT_TO_RIGHT:
		return Vector2i(shift, 0)
	return Vector2i(0, shift)


func _to_string() -> String:
	var text = ""
	var shift = calculate_shift()

	text += "Definition : " + self._definition
	text += "\nAnswer : " + self._answer
	text += "\nIntersection : " + self._intersection
	text += "\nDirection : " + str(self._direction)
	text += "\nShift from center x : " + str(shift.x)
	text += "\nShift from center y : " + str(shift.y)

	return text


func get_length() -> int:
	return self._answer.length()
