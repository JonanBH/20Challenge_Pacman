extends Node

signal score_changed
signal lives_changed

var score : int = 0
var hi_score : int = 10000
var lives : int = 3

func reset():
	score = 0
	lives = 3


func add_score(amount : int):
	score += amount
	score_changed.emit()


func change_lives(amount : int):
	var old_lives = lives
	lives = clamp(lives + amount, 0, 4)
	
	if old_lives != lives:
		lives_changed.emit()
