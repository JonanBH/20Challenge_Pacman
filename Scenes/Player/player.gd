extends CharacterBody2D

signal died
signal power_close_to_end
signal power_finished

@export var SPEED = 300.0

@onready var power_dot_delay = $PowerDotDelay
@onready var close_to_finish_power_dot = $CloseToFinishPowerDot
@onready var enemy_detector = $EnemyDetector

var current_direction = "right"
var is_alive := true

var directions = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right":Vector2.RIGHT
}

var angles = {
	"up": -90,
	"down": 90,
	"left": 180,
	"right":0
}

@onready var sprite = $AnimatedSprite2D
@onready var raycasts = {
	"up": $Raycasts/ShapeCast2D_up,
	"down": $Raycasts/ShapeCast2D_down,
	"left": $Raycasts/ShapeCast2D_left,
	"right": $Raycasts/ShapeCast2D_right
}

var buffered_move : String = ""


func _process(delta):
	if Input.is_action_pressed("up"):
		buffered_move = "up"
	if Input.is_action_pressed("down"):
		buffered_move = "down"
	if Input.is_action_pressed("left"):
		buffered_move = "left"
	if Input.is_action_pressed("right"):
		buffered_move = "right"
	pass

func _physics_process(delta):
	if !is_alive:
		return
		
	if buffered_move != "":
		if(!raycasts[buffered_move].is_colliding()):
			current_direction = buffered_move
			buffered_move = ""
			sprite.rotation = deg_to_rad(angles[current_direction])
	
	velocity = directions[current_direction] * SPEED 
	move_and_slide()


func enable_power_dot():
	power_dot_delay.stop()
	close_to_finish_power_dot.stop()
	power_dot_delay.start()
	close_to_finish_power_dot.start()
	enemy_detector.monitoring = true

func _on_power_dot_delay_timeout():
	enemy_detector.monitoring = false
	power_finished.emit()


func _on_enemy_detector_body_entered(body):
	print("Try to eat enemy")
	body.eaten()


func _on_close_to_finish_power_dot_timeout():
	power_close_to_end.emit()


func die():
	if !is_alive:
		return
	
	is_alive = false
	velocity =  Vector2.ZERO
	died.emit()


func reset():
	is_alive = true
