extends VBoxContainer

var _is_dragging: bool = false
var _drag_offset: Vector2
var _max_length: int


func _ready() -> void:
	_create_buttons()
	$Background/Keyboard/ThirdRow/Backspace.connect(
		"pressed", _on_button_pressed.bind($Background/Keyboard/ThirdRow/Backspace)
	)
	$Background/Keyboard/ThirdRow.move_child($Background/Keyboard/ThirdRow/Backspace, -1)


func reset():
	$Background/Display/Label.set_text("")
	self.visible = false


func set_definition(text: String, length: int):
	$Definition/Label.set_text(text + " [" + str(length) + "]")


func _create_button(letter: String) -> Button:
	var button = preload("res://scenes/components/buttons/square_button.tscn").instantiate()
	button.get_node("Text").set_text(letter)
	button.set_name("Button" + letter)
	button.connect("pressed", _on_button_pressed.bind(button))
	return button


func _create_buttons() -> void:
	var rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]

	var i = 0
	for child in $Background/Keyboard.get_children():
		if child is HBoxContainer:
			for letter in rows[i]:
				child.add_child(_create_button(letter))
			i += 1


func _new_text(button_pressed) -> String:
	var text = $Background/Display/Label.get_text() as String

	if button_pressed == $Background/Keyboard/ThirdRow/Backspace:
		text = text.substr(0, text.length() - 1)
		return text

	if button_pressed != $Background/Confirm:
		if text.length() < _max_length:
			text += button_pressed.get_node("Text").get_text()

	return text


func _on_button_pressed(button):
	$Background/Display/Label.set_text(_new_text(button))


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_is_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
		else:
			_is_dragging = false


func _process(_delta):
	if _is_dragging:
		var mouse_pos = get_viewport().get_mouse_position() - _drag_offset
		var screen_size = get_viewport_rect().size

		# Clamp la posizione per restare dentro lo schermo
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_size.x - self.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_size.y - self.size.y)

		global_position = mouse_pos


func _press_button(button: Button) -> void:
	button.pressed.emit()
	button.toggle_mode = true
	button.set_pressed_no_signal(true)
	await get_tree().create_timer(0.2).timeout
	button.set_pressed_no_signal(false)
	button.toggle_mode = false


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		var key_string = OS.get_keycode_string(event.keycode)
		if key_string.length() == 1:
			if key_string >= "a" and key_string <= "z" or key_string >= "A" and key_string <= "Z":
				var button_name = "Button" + key_string
				var button_node = $Background/Keyboard.find_child(button_name, true, false)
				_press_button(button_node)
		elif key_string == "Backspace":
			_press_button($Background/Keyboard/ThirdRow/Backspace)
