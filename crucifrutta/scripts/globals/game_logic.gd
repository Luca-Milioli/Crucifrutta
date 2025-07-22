extends Node	# needed for autoload (singleton)

const MAX_ROUND = 1

var _correct_answers: int = 0

func get_correct_answers() -> int:
	return self._correct_answers

func answer_given(answer: int, equation: Equation) -> void:
	if answer == equation.calculate_result():
		_correct_answers += 1

func win() -> bool:
	return self._correct_answers >= MAX_ROUND

func reset() -> void:
	self._correct_answers = 0
