extends TextureButton

class_name CharBox

func _ready():
	self.modulate.a = 0
	
func _on_tree_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
