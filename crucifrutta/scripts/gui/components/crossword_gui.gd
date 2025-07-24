extends GridContainer

signal spawn_keyboard

var _child_list : Array = []
var _selected_row : Array = []

func setup(charMatrix : Array[Array], highlighted_column : int):
	var charbox_to_instantiate = preload("res://scenes/components/char_box.tscn")
	var emptybox_to_instantiate = preload("res://scenes/components/empy_cell.tscn")
	var graybox_to_instantiate = preload("res://scenes/components/gray_char_box.tscn")
	var orange_texture = preload("res://art/graphics/slots/OrangeSlot.png")
	var orange_texture_hover = preload("res://art/graphics/slots/OrangeHoverSlot.png")
	
	for row in charMatrix:
		var i = 0
		for char in row:
			var box : Node
			match char:
				"":
					box = emptybox_to_instantiate.instantiate()
				null:
					box = graybox_to_instantiate.instantiate()
				_:
					box = charbox_to_instantiate.instantiate()
					if i == highlighted_column:
						box.set("texture_normal", orange_texture)
						box.set("texture_disabled", orange_texture)
						box.set("texture_hover", orange_texture_hover)
						box.set("texture_pressed", orange_texture_hover)
					box.connect("pressed", _on_charbox_clicked.bind(row))
			
			self._child_list.append(box)
			i += 1

func _on_timer_timeout() -> void:
	add_child(self._child_list.pop_front())
	
	$Timer.stop()
	
	var front = get_child(-1)
	while front is not CharBox and self._child_list.size() > 0:
		add_child(self._child_list.pop_front())
		front = self._child_list.front()
		
	$Timer.start()

func _on_charbox_clicked(row):
	self.spawn_keyboard.emit()
	self._selected_row = row

func _on_confirm_pressed() -> void:
	var text : String = $"../Keyboard/Display/Label".get_text()
	
	var i = 0
	while self._selected_row[i] is not CharBox:
		i+=1
	
	var j = 0
	while self._selected_row[i] is CharBox:
		self._selected_row[i] = text[j]
		j += 1
	
