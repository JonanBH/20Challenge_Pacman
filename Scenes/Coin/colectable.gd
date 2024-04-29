extends Area2D
class_name Colectable

signal colected

func _on_colected():
	pass

func _on_body_entered(body):
	_on_colected()
	colected.emit()
	queue_free()
