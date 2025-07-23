extends Node	# needed for autoload (singleton)

signal correct_answer
signal wrong_answer
signal crossword_finished
signal finished

const MAX_ROUND = 1

var _correct_crosswords: int = 0
var _n_words: int = 0
var _correct_words: int = 0

func set_total_words(n_words: int) -> void:
	self._n_words = n_words

func answer_given(answer: String, word: CrosswordItem) -> void:
	if answer == word.get_answer():
		self.correct_answer.emit()
		_correct_words += 1
		if self._correct_words >= self._n_words:
			self.crossword_finished.emit()
			_correct_crosswords += 1
			_reset_crossword()
			if win():
				self.finished.emit()
	else:
		self.wrong_answer.emit()

func win() -> bool:
	return self._correct_crosswords >= MAX_ROUND

func _reset_crossword() -> void:
	self._correct_words = 0
	self._n_words = 0

func reset() -> void:
	self._correct_crosswords = 0
	_reset_crossword()
