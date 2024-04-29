extends CharacterBody2D


@export var SPEED = 300.0

var current_direction = "right"



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
	"up": $Raycasts/RayCast2D_up,
	"down": $Raycasts/RayCast2D_down,
	"left": $Raycasts/RayCast2D_left,
	"right":$Raycasts/RayCast2D_right
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
	if buffered_move != "":
		if(!raycasts[buffered_move].is_colliding()):
			current_direction = buffered_move
			buffered_move = ""
			sprite.rotation = deg_to_rad(angles[current_direction])
	
	velocity = directions[current_direction] * SPEED 
	move_and_slide()
