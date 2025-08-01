extends TextureButton

class_name CharBox
var animating = false

func _ready():
	self.modulate.a = 0

func is_animating() -> bool:
	return self.animating
	
func _on_tree_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
func wrong_animation() -> void:
	self.animating = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	var start_pos = $Char.get("position")
	tween.tween_property($Char, "position", start_pos + Vector2(-20, 0), 0.1).set_delay(0.1)
	tween.tween_property($Char, "position", start_pos + Vector2(+20, 0), 0.1).set_delay(0.2)
	tween.tween_property($Char, "position", start_pos, 0.1).set_delay(0.3)
	tween.finished.connect(func(): self.animating = false)
	await tween.finished
	
	
func correct_animation() -> void:
	self.animating = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	var start_pos = $Char.get("position")
	tween.tween_property($Char, "position", start_pos + Vector2(0, -14), 0.25).set_delay(0.4)
	tween.tween_property($Char, "rotation", $Char.get("rotation")+2*PI, 0.5).set_delay(0.7)
	tween.tween_property($Char, "position", start_pos, 0.25).set_delay(1.5)
	tween.finished.connect(func(): self.animating = false)
