## Class that extends the BaseButton and represents a BaseButton with tap sound on press.
extends BaseButton
class_name CustomButton


## Plays the tap audio when the button is pressed.
func _on_pressed() -> void:
	AudioManager.tap()
