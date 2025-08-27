## Singleton script for creating crossword objects.
extends DataManager


## Returns a crossword object reading csv.
func create_crossword() -> Crossword:
	super.read_csv()

	if self.all_crosswords.is_empty():
		return null

	var n_words = self.all_crosswords.front().size()

	var crossword_items: Array[CrosswordItem]
	for i in n_words:
		var dict = self.all_crosswords.front()[i]
		var crossword_item
		if dict:
			crossword_item = CrosswordItem.new(
				dict["definition"], dict["answer"], dict["intersection"], dict["help_char"]
			)
		else:
			crossword_item = CrosswordItem.new("", "", "", "")
		crossword_items.append(crossword_item)
	var crossword = Crossword.new(crossword_items)
	GameLogic.set_current_crossword(crossword)

	self.all_crosswords.pop_front()
	return crossword
