## Main script.
extends Node
class_name Main

## Window of browser. Different from get_window()
var window
## True if this game is running on mobile.
var mobile: bool

## Checks if node gui is ready (if yes, game can start) or not yet.
## In the v2 version there's not main menu so the gui is already in scene.
## Connects some signal of get_window.
func _ready() -> void:
	self.mobile = (
		OS.has_feature("mobile") or OS.has_feature("web_ios") or OS.has_feature("web_android")
	)
	if OS.get_name() == "Web":
		self.window = JavaScriptBridge.get_interface("window").parent
		get_window().focus_entered.connect(_on_window_focus_entered)
		get_window().focus_exited.connect(_on_window_focus_exited)

	if $SubViewportContainer/SubViewport.has_node("Gui"):
		_gameplay()


## When window is not in background anymore, it resumes the audio.
func _on_window_focus_entered() -> void:
	AudioManager.set_paused(false)


## When window goes in background, it pauses the audio.
func _on_window_focus_exited() -> void:
	AudioManager.set_paused(true)


## Resize viewport as viewportcontainer.
## Checks every frame the screen orientation and stops the game (mobile only).
func _process(_delta):
	$SubViewportContainer/SubViewport.size = $SubViewportContainer.size
	
	if self.mobile:
		if window.matchMedia("(orientation: portrait)").matches:
			$SubViewportContainer/SubViewport/RotateWarning.visible = true
			set_paused(true)
		else:
			$SubViewportContainer/SubViewport/RotateWarning.visible = false
			set_paused(false)


## Put the game and the audio in pause.
func set_paused(paused: bool) -> void:
	if paused != get_tree().paused:
		get_tree().paused = paused
		AudioManager.set_paused(paused)


## URL is the "parent" of the actual URL.
## When "back" button is pressed on menu, calls the URL using javascript eval function.
## if the game is a webexport. Quits the application otherwise.
func _on_end_menu_back_pressed():
	if OS.get_name() == "Web":
		var URL = JavaScriptBridge.call(
			"eval", "top.location.href.split('/').slice(0, -2).join('/');"
		)
		JavaScriptBridge.call("eval", "top.location.href = '" + URL + "';")
	else:
		get_tree().quit()


## When "play" button is pressed, main menu gets killed and the gui scene is instantiated.
## Now the game can start (in v2, this method is never called)
func _on_menu_play_pressed() -> void:
	var menu = $SubViewportContainer/SubViewport.get_node("Menu")
	await menu.kill()

	$SubViewportContainer/SubViewport.remove_child(menu)
	menu.queue_free()

	var gui = preload("res://scenes/main_gui/gui.tscn").instantiate()
	$SubViewportContainer/SubViewport.add_child(gui)

	_gameplay()


## Main function of the game. Creates rounds, setups end menu and awaits until the game
## is over.
func _gameplay():
	$SubViewportContainer/SubViewport/Gui.get_node("ResetPopup/SplitContainer/Go").pressed.connect(
		_on_reset
	)

	await _create_rounds()

	var end_menu = preload("res://scenes/main_gui/menu/end_menu.tscn").instantiate()

	end_menu.back_pressed.connect(_on_end_menu_back_pressed)
	end_menu.play_pressed.connect(_on_reset)

	await $SubViewportContainer/SubViewport/Gui.kill()
	$SubViewportContainer/SubViewport/Gui.queue_free()

	$SubViewportContainer/SubViewport.add_child(end_menu)


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

		$SubViewportContainer/SubViewport/Gui.crossword_setup(crossword)

		await GameLogic.crossword_finished
		await $SubViewportContainer/SubViewport/Gui.crossword_finished()

	$SubViewportContainer/SubViewport/Gui.game_over()


## Called when a child is added. It moves FullScreenButton in last position.
func _on_child_entered_tree(node: Node) -> void:
	if $SubViewportContainer/SubViewport.has_node("FullScreenButton"):
		$SubViewportContainer/SubViewport.move_child.call_deferred(
			$SubViewportContainer/SubViewport/FullScreenButton, -1
		)
