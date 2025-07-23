extends CommonModels

class_name CrosswordItem

var _question : StringName
var _answer : StringName
var _intersection : StringName

func _init(question : StringName, answer : StringName, intersection : StringName) -> void:
	super._set("self._question", question)
	super._set("self._answer", answer)
	super._set("self._intersection", intersection)
