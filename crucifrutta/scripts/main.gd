## Main script.
extends Node
class_name Main

## URL where games are hosted.
const URL = "https://spreafico.net/"


## Checks if node gui is ready (if yes, game can start) or not yet.
## In the v2 version there's not main menu so the gui is already in scene.
func _ready() -> void:
	if has_node("Gui"):
		_gameplay()


## When "back" button is pressed on menu, calls the URL using javascript eval function
## if the game is a webexport. Quits the application otherwise.
func _on_end_menu_back_pressed():
	if OS.get_name() == "Web":
		var js = Engine.get_singleton("JavaScriptBridge")
		js.call("eval", "window.location.href = '" + URL + "';")
	else:
		get_tree().quit()


## When "play" button is pressed, main menu gets killed and the gui scene is instantiated.
## Now the game can start (in v2, this method is never called)
func _on_menu_play_pressed() -> void:
	var menu = get_node("Menu")
	await menu.kill()

	remove_child(menu)
	menu.queue_free()

	var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()
	add_child(gui)

	_gameplay()


## Main function of the game. Creates rounds, setups end menu and awaits until the game
## is over.
func _gameplay():
	$Gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(_on_reset)

	await _create_rounds()

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	end_menu.back_pressed.connect(_on_end_menu_back_pressed)
	end_menu.play_pressed.connect(_on_reset)

	await $Gui.kill()
	$Gui.queue_free()

	add_child(end_menu)


## Resets every singleton and reload the current scene.
## Called every time the game restarts.
func _on_reset():
	GameLogic.reset()
	CrosswordFactory.reset()
	AudioManager.reset()
	get_tree().reload_current_scene()


## Creates the correct number of rounds. Calls the factory, awaits the turn end
## and calls game_over.
func _create_rounds():
	for i in range(GameLogic.MAX_ROUND):
		var crossword = CrosswordFactory.create_crossword()

		$Gui.crossword_setup(crossword)

		await GameLogic.crossword_finished
		await $Gui.crossword_finished()

	$Gui.game_over()


## Called when a child is added. It moves FullScreenButton in last position.
func _on_child_entered_tree(node: Node) -> void:
	if has_node("FullScreenButton"):
		move_child.call_deferred($FullScreenButton, -1)
