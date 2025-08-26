## Class that represents an item of crossword. It contains definition, answer, intersection and direction.
class_name CrosswordItem

## Direction: left-to-right or up-to-down.
enum DIRECTION { LEFT_TO_RIGHT, UP_TO_DOWN }

## Definition (question) visible in the display.
var _definition: String

## Correct answer of the item.
var _answer: String

## First char that intersects with the final word.
var _intersection: String

## Direction of the crossword item.
var _direction: DIRECTION


## Creates a crossword item giving parameters. Default direction is left-to-right.
func _init(
	definition: String, answer: String, intersection: String, direction = DIRECTION.LEFT_TO_RIGHT
) -> void:
	set("_definition", definition)
	set("_answer", answer)
	set("_intersection", intersection)
	set("_direction", direction)


## Calculates the shift depending on the intersection character
## (the intersection character is always centered).
func calculate_shift() -> Vector2i:
	var shift = self._answer.find(self._intersection.to_upper())

	if _direction == DIRECTION.LEFT_TO_RIGHT:
		return Vector2i(shift, 0)
	return Vector2i(0, shift)


## To string method, usefull for debug.
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


## Returns the answer length.
func get_length() -> int:
	return self._answer.length()
