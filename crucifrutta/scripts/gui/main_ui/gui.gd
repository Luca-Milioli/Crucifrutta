extends CommonUI
	
func game_over():
	super.fade_out($TopBar/Text)
	
func _on_tree_entered() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($".")
	await super.fade_in($TutorialPopup)
	Utils.recursive_disable_buttons($TutorialPopup, false)

func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons(self,false)
	$TutorialPopup/SplitContainer/Go.disabled = true
	await super.fade_out($TutorialPopup)
	$TutorialPopup.queue_free()
	$Crossword.visible = true
	$Crossword/Timer.start()
	$TopBar.text_first_entrance()

func kill() -> void:
	await super.fade_out(self, 0.4)

func crossword_setup(crossword: Crossword) -> void:
	var crossword_gui = preload("res://scenes/components/crossword.tscn").instantiate()
	
	const size_box = Vector2(36, 36)
	var separation = Vector2(crossword_gui.get_theme_constant("h_separation"), crossword_gui.get_theme_constant("v_separation"))
	var length = crossword.get_length()
	var height = crossword.get_height()
	
	crossword_gui.set("columns", length)
	crossword_gui.setup(crossword.to_matrix(), crossword.column_highlighted())
	
	add_child(crossword_gui)
	
	crossword_gui.set("size", Vector2((size_box.x + separation.x) * length, (size_box.y + separation.y) * height))
	crossword_gui.set("position", Vector2(121.5, 135 + size_box.y))
	
	crossword_gui.connect("spawn_keyboard", _on_spawn_keyboard)

func _on_spawn_keyboard() -> void:
	print("AAAAAAAA : ")
	Utils.recursive_disable_buttons(self, true)
	Utils.recursive_disable_buttons($Keyboard, false)
	$Keyboard.visible = true
	$Keyboard.set_definition(GameLogic.get_item_definition($Crossword.get("_selected_row_index")))
	super.fade_in($Keyboard, 1.0, 0.8)

func crossword_finished() -> void:
	super.fade_out($Crossword)

func _close_keyboard() -> void:
	await super.fade_out($Keyboard)
	$Keyboard.reset()
	Utils.recursive_disable_buttons(self, false)


func _on_close_button_pressed() -> void:
	_close_keyboard()

func _on_confirm_pressed() -> void:
	var text : String = $Keyboard/Background/Display/Label.get_text()
	$Crossword.change_row_text(text)
	
	if GameLogic.answer_given(text, $Crossword.get("_selected_row_index")):
		print("BANANA")
	else:
		$Crossword.clear_row_text()
