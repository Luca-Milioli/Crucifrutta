## Main gui class, it contains every gui object.
extends CommonUI
class_name Gui


## Called when the game is over, it despawns the topbar text.
func game_over():
	super.fade_out($TopBar/Text)


## Fades in and animations when it enters the scene tree.
func _on_tree_entered() -> void:
	await super.fade_in($".")
	$Crossword/Timer.start()
	$TutorialPopup.queue_free()
	$TopBar.text_first_entrance()


## Fades in and animations when it enters the scene tree.
## It spawns the tutorial popup too (only v1).
func _on_tree_entered_with_tutorial() -> void:
	Utils.recursive_disable_buttons(self, true)
	await super.fade_in($".")
	await super.fade_in($TutorialPopup)
	Utils.recursive_disable_buttons($TutorialPopup, false)


## Called when tutorial popup has to be despawned so the game can start.
## It enables buttons and setup things.
func _on_tutorial_popup_game_start() -> void:
	Utils.recursive_disable_buttons($TutorialPopup, true)
	await super.fade_out($TutorialPopup)
	Utils.recursive_disable_buttons(self, false)
	$Crossword/Timer.start()
	$TutorialPopup.queue_free()
	$TopBar.text_first_entrance()


## Fades out itself.
func kill() -> void:
	await super.fade_out(self, 0.4)


## Setups the crossword gui object.
func crossword_setup(crossword: Crossword) -> void:
	var crossword_gui = preload("res://scenes/components/crossword.tscn").instantiate()

	const size_box = Vector2(36, 36)
	var separation = Vector2(
		crossword_gui.get_theme_constant("h_separation"),
		crossword_gui.get_theme_constant("v_separation")
	)
	var length = crossword.get_length()
	var height = crossword.get_height()

	crossword_gui.gui_checks(crossword.left_length(), height)

	crossword_gui.set("columns", length)
	crossword_gui.setup(crossword.to_matrix(), crossword.column_highlighted())

	add_child(crossword_gui)

	if not has_node("TutorialPopup"):
		$Crossword/Timer.start()

	crossword_gui.set(
		"size", Vector2((size_box.x + separation.x) * length, (size_box.y + separation.y) * height)
	)
	crossword_gui.set(
		"position", Vector2(121.5 + (36 * (11 - crossword.left_length() - 1)), 135 + size_box.y)
	)

	crossword_gui.connect("spawn_keyboard", _on_spawn_keyboard)


## Called when the keyboard spawns. It setup the keyboard scene for that call.
## (definition, answer length...)
func _on_spawn_keyboard() -> void:
	var row_index = $Crossword.get("_selected_row_index")
	var answer_length = GameLogic.get_answer(row_index).length()
	$Keyboard.set("_max_length", answer_length)

	Utils.recursive_disable_buttons(self, true)
	Utils.recursive_disable_buttons($Keyboard, false)
	$Keyboard.visible = true
	$Keyboard.set_definition(GameLogic.get_item_definition(row_index), answer_length)
	super.fade_in($Keyboard, 1.0, 0.8)


## Called when the crossword is finished. It plays a fade out animation and removes the crossword.
func crossword_finished() -> void:
	var cr = $Crossword
	await super.fade_out(cr)
	remove_child(cr)
	cr.queue_free()


## Closes the keyboard with a fadeout and resets its paramters.
func _close_keyboard() -> void:
	await super.fade_out($Keyboard)
	$Keyboard.reset()
	Utils.recursive_disable_buttons(self, false)


## Called when close button is pressed. It closes the keyboard.
func _on_close_button_pressed() -> void:
	_close_keyboard()


## Called when confirm button is pressed. It changes the row text, calls to check if the
## given answer is correct, play correct or wrong audio and animates eveything.
func _on_confirm_pressed() -> void:
	var text: String = $Keyboard/Background/Display/Label.get_text()
	$Crossword.change_row_text(text)

	await _close_keyboard()
	if not GameLogic.answer_given(text, $Crossword.get("_selected_row_index")):
		AudioManager.wrong()
		await $Crossword.animate_row(false)
		$Crossword.clear_row_text()
	else:
		AudioManager.correct()
		if $Crossword:
			$Crossword.animate_row(true)
			$Crossword.disable_row()
		if $Crossword/IdleAnimation.is_stopped():
			$Crossword/IdleAnimation.start()
