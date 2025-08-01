extends Node

signal crossword_finished
signal finished

var MAX_ROUND

var _correct_crosswords: int = 0
var _n_words: int = 0
var _correct_words: int = 0
var _current_crossword: Crossword


func _ready() -> void:
	MAX_ROUND = DataManager.get_max_rounds()


func get_max_round() -> int:
	return MAX_ROUND


func set_current_crossword(crossword: Crossword) -> void:
	self._current_crossword = crossword
	set_total_words(crossword.get_n_words())


func get_current_crossword() -> Crossword:
	return self._current_crossword


func get_answer(index: int) -> String:
	return self._current_crossword.get("_crossword_items")[index].get("_answer")


func get_item_definition(index: int) -> String:
	return self._current_crossword.get("_crossword_items")[index].get("_definition")


func set_total_words(n_words: int) -> void:
	self._n_words = n_words


func answer_given(answer: String, index: int) -> bool:
	if answer == get_answer(index):
		_correct_words += 1
		if self._correct_words >= self._n_words:
			_reset_crossword()
			self.crossword_finished.emit()
			_correct_crosswords += 1
			if win():
				self.finished.emit()
		return true
	return false


func win() -> bool:
	return self._correct_crosswords >= MAX_ROUND


func _reset_crossword() -> void:
	self._correct_words = 0
	self._n_words = 0


func reset() -> void:
	self._correct_crosswords = 0
	_reset_crossword()
