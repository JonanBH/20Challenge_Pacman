extends Node

signal score_changed
signal lives_changed

var score : int = 0
var hi_score : int = 10000
var lives : int = 3

const HI_SCORE_TAG : String = "hi_score"

var levels = [
	"res://Scenes/Level/level.tscn",
	"res://Scenes/Level/level2.tscn"
]

func reset():
	score = 0
	lives = 3
	hi_score = PlayerPrefs.get_pref(HI_SCORE_TAG, 5000)


func add_score(amount : int):
	score += amount
	score_changed.emit()


func change_lives(amount : int):
	var old_lives = lives
	lives = clamp(lives + amount, 0, 4)
	
	if old_lives != lives:
		lives_changed.emit()


func set_new_high_score(_score : int):
	hi_score = _score
	PlayerPrefs.set_pref(HI_SCORE_TAG, hi_score)


func load_random_level():
	get_tree().change_scene_to_file(_get_random_scene())


func _get_random_scene():
	return levels[randi_range(0, levels.size() - 1)]
