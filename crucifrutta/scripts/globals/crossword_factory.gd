extends DataManager

func create_crossword() -> Crossword:
	GameLogic.set_total_words(super.read_csv().size())
	return Crossword.new(super.read_csv())
