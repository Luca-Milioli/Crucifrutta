## Script that manages every game menu (start menu, win menu, lose menu, ...).
extends CommonUI
class_name Menu

## Emitted when the "play" button is pressed.
signal play_pressed

## Emitted when the "back" button is pressed.
signal back_pressed


## Emits the play_pressed signal.
func _on_play_pressed() -> void:
	play_pressed.emit()


## Emits the back_pressed signal.
func _on_back_pressed() -> void:
	back_pressed.emit()


## Checks what tyoe of menu it is (main menu or end menu) and plays the correct audio
## and animation.
func _on_tree_entered() -> void:
	if get_name() == "EndMenu":
		AudioManager.win()
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 1.3)


## Fades out itself.
func kill():
	await super.fade_out(self, 0.4)
