extends Area2D
class_name Colectable

@export var SCORE : int = 50
@export var randomize_pich : bool = true
@onready var collected_audio = $CollectedAudio
@onready var collision_shape_2d = $CollisionShape2D
@onready var sprite_2d = $Sprite2D

var already_collected : bool = false

signal colected

func _on_colected():
	GameState.add_score(SCORE)
	
	if(randomize_pich):
		collected_audio.pitch_scale += randf_range(-0.2, 0.2)
	collected_audio.play()

func _on_body_entered(body):
	if already_collected:
		return
	
	already_collected = true
	_on_colected()
	colected.emit()
	sprite_2d.hide()
	get_tree().create_timer(0.5).timeout.connect(queue_free)
	#call_deferred("queue_free")
