extends Control

@onready var lb_hi_score = $LB_HiScore
@onready var panel_container = $PanelContainer
@onready var panel_credits = $Panel_Credits

func _ready():
	var hi_score = PlayerPrefs.get_pref(GameState.HI_SCORE_TAG, 5000)
	lb_hi_score.text = str(hi_score)
	$PanelContainer/NinePatchRect/HBoxContainer/VBoxContainer/Btn_Play.grab_focus()
	AudioPlayer.play_track(0)

func _on_btn_play_pressed():
	GameState.reset()
	GameState.load_random_level()


func _on_btn_quit_pressed():
	get_tree().quit()


func _on_btn_credits_pressed():
	panel_container.hide()
	panel_credits.show()
	$Panel_Credits/NinePatchRect/Btn_Credits_Back.grab_focus()


func _on_btn_credits_back_pressed():
	panel_container.show()
	panel_credits.hide()
	$PanelContainer/NinePatchRect/HBoxContainer/VBoxContainer/Btn_Play.grab_focus()
