extends CommonUI

signal play_pressed
signal back_pressed

func _on_play_pressed() -> void:
	play_pressed.emit()

func _on_back_pressed() -> void:
	back_pressed.emit()

func _on_tree_entered() -> void:
	var tween = create_tween()
	self.modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, 1.3)
	
func kill():
	await super.fade_out(self, 0.4)
	
