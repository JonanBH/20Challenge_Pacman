extends CharacterBody2D
class_name Enemy

var target = null

enum State{
	IDLE,
	FOLLOW,
	FLEE,
	SCATTER,
	RESPAWN
}

@export var  SPEED : float = 300.0
@export var SCATTER_SPEED : float = 150
@export var SCATTER_POSITION : NodePath

var current_state := State.FOLLOW

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var scatter_node = get_node(SCATTER_POSITION)

func _follow_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()


func _idle_AI():
	pass


func _scatter_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()


func _flee_AI():
	pass
	
	
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
			_idle_AI()
		State.FLEE:
			_flee_AI()
		State.RESPAWN:
			_respawn_AI()
	
