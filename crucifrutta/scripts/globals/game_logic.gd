## Script that contains main logic of the game. It manages what happens after user
## interactions and how to end the game.

extends Node
class_name GameLogicScript

## Emitted when a crossword is finished.
signal crossword_finished

## Emitted when the game is over.
signal finished

## Max number of rounds.
var MAX_ROUND

## Number of correct crosswords.
var _correct_crosswords: int = 0

## Number of words in a crossword.
var _n_words: int = 0

## Number of correct words in a crossword.
var _correct_words: int = 0

## Reference to the current crossword.
var _current_crossword: Crossword


## Setup variables.
func _ready() -> void:
	MAX_ROUND = DataManager.get_max_rounds()


## Getter for max rounds.
func get_max_round() -> int:
	return MAX_ROUND


## Setter for current crossword.
func set_current_crossword(crossword: Crossword) -> void:
	self._current_crossword = crossword
	set_total_words(crossword.get_n_words())


## Getter for current crossword.
func get_current_crossword() -> Crossword:
	return self._current_crossword


## Getter for the correct answer of a crossword line (word).
func get_answer(index: int) -> String:
	return self._current_crossword.get("_crossword_items")[index].get("_answer")


## Getter for the item definition of a crossword line (word).
func get_item_definition(index: int) -> String:
	return self._current_crossword.get("_crossword_items")[index].get("_definition")


## Setter for total words of a crossword.
func set_total_words(n_words: int) -> void:
	self._n_words = n_words


## Checks if the answer given is correct and returns true/false.
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


## Checks if user won the game.
func win() -> bool:
	return self._correct_crosswords >= MAX_ROUND


## Resets crossword to default. called when the game restarts.
func _reset_crossword() -> void:
	self._correct_words = 0
	self._n_words = 0


## Resets game logic to default. Called when the game restarts.
func reset() -> void:
	self._correct_crosswords = 0
	_reset_crossword()
