extends CanvasLayer

@onready var lb_score = $VBoxContainer/HB_Score/LB_Score
@onready var hb_lives_count = $HB_Lives/HB_Lives_Count

func _ready():
	GameState.score_changed.connect(update_score)
	GameState.lives_changed.connect(update_lives)
	update_score()
	update_lives()


func update_score():
	lb_score.text = str(GameState.score)

func update_lives():
	for index in range(0, hb_lives_count.get_child_count()):
		var child = hb_lives_count.get_child(index)
		child.visible = index < GameState.lives
