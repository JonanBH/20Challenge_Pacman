extends Control

@onready var lb_hi_score = $LB_HiScore

func _ready():
	var hi_score = PlayerPrefs.get_pref(GameState.HI_SCORE_TAG, 5000)
	lb_hi_score.text = str(hi_score)
	$PanelContainer/NinePatchRect/HBoxContainer/VBoxContainer/Btn_Play.grab_focus()

func _on_btn_play_pressed():
	GameState.reset()
	GameState.load_random_level()


func _on_btn_quit_pressed():
	get_tree().quit()
