extends CharacterBody2D
class_name Enemy

signal died(character)

var target = null

enum State{
	IDLE,
	FOLLOW,
	FLEE,
	SCATTER,
	RESPAWN
}

@export var  SPEED : float = 300.0
@export var FLEE_SPEED : float = 150.0
@export var SCATTER_SPEED : float = 150
@export var SCATTER_POSITION : NodePath

var current_state := State.FOLLOW

@onready var random_idle_animation_begin := randf_range(0.0025, 0.006)
@onready var current_speed = SPEED
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_node = get_node(SCATTER_POSITION)
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var weak_sprite = $WeakSprite
@onready var current_position : Vector2 = position
@onready var audio_eaten = $Audio_Eaten


func _ready():
	call_deferred("_remove_collision_wth_ghosts")


func _remove_collision_wth_ghosts():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var players = get_tree().get_nodes_in_group("player")
	add_collision_exception_with(players[0])
	for enemy in enemies:
		if enemy != self:
			add_collision_exception_with(enemy)


func _follow_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * current_speed
	
	move_and_slide()


func _idle_AI():
	position = current_position + Vector2.UP * sin(Time.get_ticks_msec() * random_idle_animation_begin) * 8


func _scatter_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * current_speed
	
	move_and_slide()


func _flee_AI():
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * current_speed
	
	move_and_slide()
	
	
func _respawn_AI():
	pass

func _physics_process(delta):
	
	match current_state:
		State.SCATTER:
			_scatter_IA()
		State.FOLLOW:
			_follow_IA()
		State.IDLE:
			_idle_AI()
		State.FLEE:
			_flee_AI()
		State.RESPAWN:
			_respawn_AI()


func _recalculate_position():
	navigation_agent_2d.target_position = target.global_position


func _on_recalculate_timer_timeout():
	if target == null:
		return
	
	match current_state:
		State.SCATTER:
			navigation_agent_2d.target_position = scatter_node.global_position
		State.FOLLOW:
			_recalculate_position()
		State.IDLE:
			pass
		State.FLEE:
			navigation_agent_2d.target_position = scatter_node.global_position
		State.RESPAWN:
			_respawn_AI()


func begin_flee_from_pacman():
	if current_state == State.IDLE:
		return
	
	animated_sprite_2d.hide()
	weak_sprite.show()
	current_state = State.FLEE
	current_speed = FLEE_SPEED


func power_close_to_end():
	pass


func end_flee_from_pacman():
	animated_sprite_2d.show()
	weak_sprite.hide()
	current_state = State.FOLLOW
	current_speed = SPEED


func eaten():
	if current_state != State.FLEE:
		return
	
	GameState.add_score(1000)
	current_speed = SPEED
	audio_eaten.play()
	died.emit(self)
	animated_sprite_2d.show()
	weak_sprite.hide()


func _on_player_detector_body_entered(body):
	if current_state == State.FLEE or current_state == State.IDLE:
		return
	
	body.die()
