extends GridContainer

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
		print(row)
		for char in row:
			var box : Node
			match char:
				"":
					box = emptybox_to_instantiate.instantiate()
				null:
					box = graybox_to_instantiate.instantiate()
				_:
					box = charbox_to_instantiate.instantiate()
					box.get_node("Char").text = char
			add_child(box)
		
		var child_to_highlight = get_child(charMatrix.find(row) * get("columns") + highlighted_column - 1)
		child_to_highlight.set("texture_normal", orange_texture)
		child_to_highlight.set("texture_disabled", orange_texture)
		child_to_highlight.set("texture_hover", orange_texture_hover)
		child_to_highlight.set("texture_pressed", orange_texture_hover)
		
