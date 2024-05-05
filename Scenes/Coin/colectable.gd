extends Area2D
class_name Colectable

@export var SCORE : int = 50

signal colected

func _on_colected():
	GameState.add_score(SCORE)

func _on_body_entered(body):
	_on_colected()
	colected.emit()
	queue_free()
