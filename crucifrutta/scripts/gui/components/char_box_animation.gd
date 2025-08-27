## Class that represents the box containing a char.
extends TextureButton
class_name CharBox

## Emitted when wrong animation is finished.
signal wrong_animation_done

## Boolean that represents when the object is animating.
var _animating = false

## True if box is a tipbox, false otherwise
var _tip = false 


## Variables setup.
func _ready():
	self.modulate.a = 0


## Getter for animating.
func is_animating() -> bool:
	return self._animating


## Getter for tip box
func is_tip_box() -> bool:
	return self._tip


## Setter for tip box
func set_tip_box(tip: bool):
	self._tip = tip


## Fade in when object enters the tree.
func _on_tree_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)


## Animation played when the given answer is wrong.
func wrong_animation() -> void:
	Utils.recursive_disable_buttons(get_parent(), true)
	self._animating = true

	var tween = create_tween()
	tween.set_parallel(true)

	var start_pos = $Char.get("position")
	tween.tween_property($Char, "position", start_pos + Vector2(-20, 0), 0.1).set_delay(0.1)
	tween.tween_property($Char, "position", start_pos + Vector2(+20, 0), 0.1).set_delay(0.2)
	tween.tween_property($Char, "position", start_pos, 0.1).set_delay(0.3)
	tween.finished.connect(func(): 
		self._animating = false
		Utils.recursive_disable_buttons(get_parent(), false)
	)
	await tween.finished
	self.wrong_animation_done.emit()


## Animation played when the given answer is correct.
func correct_animation() -> void:
	self._animating = true

	var tween = create_tween()
	tween.set_parallel(true)

	var start_pos = $Char.get("position")
	tween.tween_property($Char, "position", start_pos + Vector2(0, -14), 0.25).set_delay(0.4)
	tween.tween_property($Char, "rotation", $Char.get("rotation") + 2 * PI, 0.5).set_delay(0.7)
	tween.tween_property($Char, "position", start_pos, 0.25).set_delay(1.5)
	tween.finished.connect(func(): self._animating = false)
