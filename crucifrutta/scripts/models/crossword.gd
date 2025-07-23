

class_name Crossword

var _crossword_items : Array[CrosswordItem]

func _init(crossword_items : Array[CrosswordItem]) -> void:
	set("_crossword_items", crossword_items)

func calculate_final_word() -> String:
	var final_word = ""
	for word in self._crossword_items:
		final_word += word.get("_intersection")
	
	return final_word
	
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
