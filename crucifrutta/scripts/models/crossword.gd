## Class that represent the Crossword model.
class_name Crossword

## Array containing every item of the crossword (rows).
var _crossword_items: Array[CrosswordItem]


## Sets the crossword items of crossword.
func _init(crossword_items: Array[CrosswordItem]) -> void:
	set("_crossword_items", crossword_items)


## Returns the final crossword word, adding every letter in the intersection.
func calculate_final_word() -> String:
	var final_word = ""
	for word in self._crossword_items:
		final_word += word.get("_intersection")

	return final_word


## To string method, usefull for debug.
func _to_string() -> String:
	var text = ""
	var i = 1

	for word in self._crossword_items:
		text += "----------------------\n"
		text += "Word " + str(i) + "\n"
		text += word.to_string() + "\n"
		i += 1

	text += "\nHighlight word: " + calculate_final_word()

	return text


## Calculate the max left length of a row (from left to center).
func left_length() -> int:  # from the beginning to column highligthed
	var left_length = 0

	for word in self._crossword_items:
		var tmp_shift = word.calculate_shift()
		var intersection = tmp_shift.x if tmp_shift.x != 0 else tmp_shift.y

		if intersection > left_length:
			left_length = intersection

	return left_length


## Calculates the max right length of a word (from center to right).
func right_length() -> int:  # from column highlighted to the end
	var right_length = 0

	for word in self._crossword_items:
		var length = word.get_length()
		var tmp_shift = word.calculate_shift()
		var intersection = tmp_shift.x if tmp_shift.x != 0 else tmp_shift.y

		if length - intersection - 1 > right_length:
			right_length = length - intersection - 1

	return right_length


## Gets the max row length (left + right + 1).
func get_length() -> int:
	return left_length() + right_length() + 1


## Gets the height of crossword (the number of words + gray buttons).
func get_height() -> int:
	return self._crossword_items.size()


## Returns the number of words.
func get_n_words() -> int:
	var n_words = 0
	for item in _crossword_items:
		if item.get_length() > 0:
			n_words += 1
	return n_words


## Returns the index of center coloumn.
func column_highlighted() -> int:
	return left_length()


## Return the list of already displayed char in the format:
## [help_char_1, answer_1], [help_char_2, answer_2], ... , [help_char_n, answer_n]
func help_list() -> Array:
	var help_list = []
	for row in _crossword_items:
		var help_char = row.get("_help_char") if row != null else null
		var to_append = row.get("_answer").to_lower().find(help_char) if not help_char.is_empty() else ""
		help_list.append([help_char, to_append])
		
	return help_list
	
	
## Clear the row (called when answer is wrong).
func empty_row(length: int) -> Array:
	var row: Array
	for i in range(length):
		row.append(null if i == column_highlighted() else "")
	return row


## Converts the object to a matrix.
func to_matrix() -> Array[Array]:
	var matrix: Array[Array]
	var left_length = left_length()
	var right_length = right_length()
	var total_length = left_length + right_length + 1

	for i in range(get_height()):
		var row: Array
		var word_length = _crossword_items[i].get_length()
		if word_length <= 0:
			matrix.append(empty_row(total_length))
		else:
			var tmp_shift = _crossword_items[i].calculate_shift()
			var intersection = tmp_shift.x if tmp_shift.x != 0 else tmp_shift.y
			var k = 0
			var added = false  # if the word is already added
			while k < total_length:
				if k < left_length - intersection or added:  # add empty string at the beginning and after the word is added
					row.append("")
					k += 1
				else:
					var j = 0
					while j < word_length:  # add the word and set the flag
						row.append(_crossword_items[i].get("_answer")[j])
						j += 1
					k += word_length
					added = true
			matrix.append(row)
	return matrix
