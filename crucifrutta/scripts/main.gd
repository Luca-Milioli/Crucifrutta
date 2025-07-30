extends Node

const URL = "https://spreafico.net/"


func _on_end_menu_back_pressed():
	if OS.get_name() == "Web":
		var js = Engine.get_singleton("JavaScriptBridge")
		js.call("eval", "window.location.href = '" + URL + "';")
	else:
		get_tree().quit()


func _on_menu_play_pressed() -> void:
	var menu = get_node("Menu")
	await menu.kill()

	remove_child(menu)
	menu.queue_free()

	await _create_rounds()

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	end_menu.back_pressed.connect(_on_end_menu_back_pressed)
	end_menu.play_pressed.connect(_on_reset)

	await $Gui.kill()
	$Gui.queue_free()

	add_child(end_menu)


func _on_reset():
	GameLogic.reset()
	CrosswordFactory.reset()
	AudioManager.reset()
	get_tree().reload_current_scene()


func _create_rounds():
	var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()

	gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(_on_reset)
	add_child(gui)

	for i in range(GameLogic.MAX_ROUND):
		var crossword = CrosswordFactory.create_crossword()

		gui.crossword_setup(crossword)

		await GameLogic.crossword_finished
		await gui.crossword_finished()

	gui.game_over()
