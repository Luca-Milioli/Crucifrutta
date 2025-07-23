extends Node
class_name DataManager

const DATA_PATH = "res://data/data_crossword.csv"
var data: Array

func read_csv(separator: String = ",") -> Array:
	if not data.is_empty():
		return data
	
	var file := FileAccess.open(self.DATA_PATH, FileAccess.READ)

	if not file:
		push_error("Error, data file not found.")
		return []

	while not file.eof_reached():
		var pos = file.get_position()
		var line = file.get_line().strip_edges()
		if line == separator or line.is_empty():	# empty word
			data.append(null)	# empty word, gray square
		else:
			file.seek(pos)	# bring back cursor
			
			var attributes = file.get_csv_line(separator)
			
			# attributes[0] = "cruciverbaN"
			var row_data : Dictionary = {
				"definition": attributes[1],
				"answer": attributes[2],
				"intersection": attributes[3],
			}
			data.append(row_data)
	
	file.close()
	return data
