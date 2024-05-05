extends CanvasLayer

@onready var lb_score = $VBoxContainer/HB_Score/LB_Score
@onready var hb_lives_count = $HB_Lives/HB_Lives_Count
@onready var lb_hi_score = $VBoxContainer/HB_HIScore/LB_HIScore
@onready var lb_new_high_score = $GameOverScreen/ColorRect/Lb_NewHighScore
@onready var lb_final_score = $GameOverScreen/ColorRect/Lb_FinalScore
@onready var game_over_screen = $GameOverScreen

func _ready():
	GameState.score_changed.connect(update_score)
	GameState.lives_changed.connect(update_lives)
	update_score()
	update_lives()


func update_score():
	lb_score.text = str(GameState.score)
	lb_hi_score.text = str(GameState.hi_score)

func update_lives():
	for index in range(0, hb_lives_count.get_child_count()):
		var child = hb_lives_count.get_child(index)
		child.visible = index < GameState.lives


func _on_btn_play_again_pressed():
	GameState.reset()
	GameState.load_random_level()


func _on_btn_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")


func show_game_over():
	lb_final_score.text = str(GameState.score)
	lb_new_high_score.visible = GameState.score > GameState.hi_score
	game_over_screen.show()
	$GameOverScreen/ColorRect/VBoxContainer/Btn_PlayAgain.grab_focus()


func show_victory_screen():
	$VictoryScreen/ColorRect/Lb_CurrentScore.text = str(GameState.score)
	$VictoryScreen.show()
	$VictoryScreen/ColorRect/VBoxContainer/Btn_NextLevel.grab_focus()

func _on_btn_next_level_pressed():
	GameState.load_random_level()
