extends Node
class_name DataManager

const DATA_PATH = "res://data/data_crossword.csv"
#const DATA_PATH = "res://data/test.csv"
var all_crosswords: Array


static func get_max_rounds():
	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	var rounds = file.get_line().to_int()
	file.close()

	return rounds


func reset():
	self.all_crosswords = []


func read_csv(separator: String = ","):
	if not all_crosswords.is_empty():
		return all_crosswords

	var file := FileAccess.open(self.DATA_PATH, FileAccess.READ)

	if not file:
		push_error("Error, data file not found.")
		return []

	# first row is MAX ROUNDS
	file.get_line()

	var data = []
	while not file.eof_reached():
		var pos = file.get_position()
		var line = file.get_line().strip_edges()
		if line == separator or line.is_empty():  # empty word
			data.append(null)  # empty word, gray square
		elif line == "|":
			self.all_crosswords.append(data)
			data = []
			continue
		else:
			file.seek(pos)  # bring back cursor

			var attributes = file.get_line().strip_edges().split(separator)

			# attributes[0] = "cruciverbaN"
			var row_data: Dictionary = {
				"definition": attributes[1],
				"answer": attributes[2],
				"intersection": attributes[3],
			}
			data.append(row_data)

	self.all_crosswords.shuffle()
	self.all_crosswords.append(data)
	file.close()
