extends DataManager

func create_crossword() -> Crossword:
	var n_words = super.read_csv().size()
	
	var crossword_items: Array[CrosswordItem]
	for i in n_words:
		var dict = super.read_csv()[i]
		var crossword_item
		if dict:
			crossword_item = CrosswordItem.new(dict["definition"], dict["answer"], dict["intersection"])
		else:
			crossword_item = CrosswordItem.new("", "", "")
		crossword_items.append(crossword_item)
	var crossword = Crossword.new(crossword_items)
	GameLogic.set_current_crossword(crossword)
	return crossword
