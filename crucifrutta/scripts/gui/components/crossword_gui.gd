extends GridContainer

signal spawn_keyboard

var _child_list : Array = []
var _selected_row_index: int

func _get_selected_row_boxes() -> Array:
	var start_index = self.get("columns") * self._selected_row_index + 1 # timer is first
	var end_index = start_index + self.get("columns")
	return get_children().slice(start_index, end_index)
	
func setup(charMatrix : Array[Array], highlighted_column : int):
	var charbox_to_instantiate = preload("res://scenes/components/char_box.tscn")
	var emptybox_to_instantiate = preload("res://scenes/components/empy_cell.tscn")
	var graybox_to_instantiate = preload("res://scenes/components/gray_char_box.tscn")
	var orange_texture = preload("res://art/graphics/slots/OrangeSlot.png")
	var orange_texture_hover = preload("res://art/graphics/slots/OrangeHoverSlot.png")
	
	var j = 0
	for row in charMatrix:
		var i = 0
		for char in row:
			var box : Node
			match char:
				"":
					box = emptybox_to_instantiate.instantiate()
					box.set_name("empty:"+str(i + (j * get("columns"))))
				null:
					box = graybox_to_instantiate.instantiate()
					box.set_name("gray:"+str(i + (j * get("columns"))))
				_:
					box = charbox_to_instantiate.instantiate()
					box.set_name("default:"+str(i + (j * get("columns"))))
					if i == highlighted_column:
						box.set("texture_normal", orange_texture)
						box.set("texture_disabled", orange_texture)
						box.set("texture_hover", orange_texture_hover)
						box.set("texture_pressed", orange_texture_hover)
						
					box.connect("pressed", _on_charbox_clicked.bind(charMatrix.find(row)))
			
			self._child_list.append(box)
			i += 1
		j += 1

func _on_timer_timeout() -> void:
	add_child(self._child_list.pop_front())
	
	$Timer.stop()
	
	var front = get_child(-1)
	while front is not CharBox and self._child_list.size() > 0:
		add_child(self._child_list.pop_front())
		front = self._child_list.front()
		
	$Timer.start()

func _on_charbox_clicked(row_index : int):
	self._selected_row_index = row_index
	
	self.spawn_keyboard.emit()

func change_row_text(text) -> void:
	var selected_row_boxes = _get_selected_row_boxes()
	
	var i = 0
	while selected_row_boxes[i] is not CharBox:
		i+=1
	
	var j = 0
	while j < text.length() and selected_row_boxes[i + j] is CharBox:
		(selected_row_boxes[i + j] as Node).get_node("Char").set_text(text[j])
		j += 1

func clear_row_text() -> void:
	for box in _get_selected_row_boxes():
		if box is CharBox:
			await get_tree().process_frame
			box.get_node("Char").set_text("")
