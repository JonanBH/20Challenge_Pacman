extends Node

@onready var audio_stream = $AudioStreamPlayer2D
@onready var tracks = [
	load("res://Assets/Audio/Music/TipTopTomCat/Caustic.mp3"),
	load("res://Assets/Audio/Music/TipTopTomCat/Take it Back.mp3"),
	load("res://Assets/Audio/Music/TipTopTomCat/Just Breathe.mp3"),
	load("res://Assets/Audio/Music/TipTopTomCat/My Heart My Soul V1.mp3"),
	load("res://Assets/Audio/Music/TipTopTomCat/My Heart My Soul V2.mp3")
]

var current_track = -1

func play_track(index : int):
	if index == current_track:
		return
	
	audio_stream.stop()
	audio_stream.stream = tracks[index]
	audio_stream.call_deferred("play")
	current_track = index
