extends GridContainer

signal spawn_keyboard

const MAX_WORD_LEFT_LENGTH = 10
const MAX_WORDS = 15

var _child_list: Array = []
var _selected_row_index: int


func gui_checks(left_length: int, max_words: int) -> bool:
	if left_length > MAX_WORD_LEFT_LENGTH or max_words > MAX_WORDS:
		push_error("crossword limit exceeded")
		return false
	return true


func _get_selected_row_boxes() -> Array:
	var start_index = self.get("columns") * self._selected_row_index + 2  # timers are first
	var end_index = start_index + self.get("columns")
	return get_children().slice(start_index, end_index)

func animate_row(correct: bool):
	if correct:
		for i in _get_selected_row_boxes():
			if i is CharBox:
				i.correct_animation()
	else:
		var last_char
		var reversed_boxes = _get_selected_row_boxes()
		reversed_boxes.reverse()
		for box in reversed_boxes:
			if box is CharBox:
				last_char = box
				break
				
		for i in _get_selected_row_boxes():
			if i is CharBox:
				if i != last_char:
					i.wrong_animation()
				else:
					await i.wrong_animation()

func setup(charMatrix: Array[Array], highlighted_column: int):
	var charbox_to_instantiate = preload("res://scenes/components/boxes/char_box.tscn")
	var emptybox_to_instantiate = preload("res://scenes/components/boxes/empy_cell.tscn")
	var graybox_to_instantiate = preload("res://scenes/components/boxes/gray_char_box.tscn")
	var orange_texture = preload("res://art/graphics/slots/OrangeSlot.png")
	var orange_texture_hover = preload("res://art/graphics/slots/OrangeHoverSlot.png")

	var j = 0
	for row in charMatrix:
		var i = 0
		for char in row:
			var box: Node
			match char:
				"":
					box = emptybox_to_instantiate.instantiate()
					box.set_name("empty:" + str(i + (j * get("columns"))))
				null:
					box = graybox_to_instantiate.instantiate()
					box.set_name("gray:" + str(i + (j * get("columns"))))
				_:
					box = charbox_to_instantiate.instantiate()
					box.set_name("default:" + str(i + (j * get("columns"))))
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
	var front = self._child_list.pop_front()
	add_child(front)

	$Timer.stop()

	while not self._child_list.is_empty() and self._child_list.front() is not CharBox:
		add_child(self._child_list.pop_front())

	if not self._child_list.is_empty():
		$Timer.start()


func _on_charbox_clicked(row_index: int):
	self._selected_row_index = row_index

	self.spawn_keyboard.emit()


func change_row_text(text) -> void:
	var selected_row_boxes = _get_selected_row_boxes()

	var i = 0
	while selected_row_boxes[i] is not CharBox:
		i += 1

	var j = 0
	while j < text.length() and selected_row_boxes[i + j] is CharBox:
		(selected_row_boxes[i + j] as Node).get_node("Char").set_text(text[j])
		j += 1


func disable_row():
	var selected_row_boxes = _get_selected_row_boxes()
	for box in selected_row_boxes:
		if box is CharBox:
			box.mouse_filter = Control.MOUSE_FILTER_IGNORE


func clear_row_text() -> void:
	for box in _get_selected_row_boxes():
		if box is CharBox:
			await get_tree().process_frame
			box.get_node("Char").set_text("")


func _on_idle_animation_timeout() -> void:
	var children = get_children()
	var char_boxes = []
	
	for child in children:
		if child.get_name().contains("default") and child.get_node("Char").text != "" and not child.is_animating():
			char_boxes.append(child)
	
	var box_to_animate = char_boxes.pick_random()
	
	if box_to_animate:
		# so correct and idle dont overlaps on the same frame
		await get_tree().process_frame
		box_to_animate.correct_animation()
