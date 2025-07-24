extends GridContainer

var _child_list : Array = []
var _selected_row : Array = []

func _ready() -> void:
	pass
# "", "", c, i, a, o, ", ""
# "", b , a, n, a, n, a, ""
func setup(charMatrix : Array[Array], highlighted_column : int):
	var charbox_to_instantiate = preload("res://scenes/components/char_box.tscn")
	var emptybox_to_instantiate = preload("res://scenes/components/empy_cell.tscn")
	var graybox_to_instantiate = preload("res://scenes/components/gray_char_box.tscn")
	var orange_texture = preload("res://art/graphics/slots/OrangeSlot.png")
	var orange_texture_hover = preload("res://art/graphics/slots/OrangeHoverSlot.png")
	
	for row in charMatrix:
		for char in row:
			var box : Node
			match char:
				"":
					box = emptybox_to_instantiate.instantiate()
				null:
					box = graybox_to_instantiate.instantiate()
				_:
					box = charbox_to_instantiate.instantiate()
					#box.get_node("Char").text = char
					box.connect("pressed", _on_charbox_clicked.bind(row))
			
			self._child_list.append(box)
		
		var child_to_highlight = self._child_list.get(charMatrix.find(row) * get("columns") + highlighted_column - 1)
		child_to_highlight.set("texture_normal", orange_texture)
		child_to_highlight.set("texture_disabled", orange_texture)
		child_to_highlight.set("texture_hover", orange_texture_hover)
		child_to_highlight.set("texture_pressed", orange_texture_hover)
	

func _on_timer_timeout() -> void:
	add_child(self._child_list.pop_front())
	
	$Timer.stop()
	
	var front = get_child(-1)
	while front is not CharBox and self._child_list.size() > 0:
		add_child(self._child_list.pop_front())
		front = self._child_list.front()
		
	$Timer.start()

func _on_charbox_clicked(row):
	self._selected_row = row
	print(self._selected_row)
	#preload("res://scenes/compnents/keyboard.tscn")
	#add_child(keyboard)
	#$"../Keyboard/Display/Label".get_text()

func _on_confirm_pressed() -> void:
	var text : String = $"../Keyboard/Display/Label".get_text()
	
	var i = 0
	while self._selected_row[i] is not CharBox:
		i+=1
	
	var j = 0
	while self._selected_row[i] is CharBox:
		self._selected_row[i] = text[j]
		j += 1
	
