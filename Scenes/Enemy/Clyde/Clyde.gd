extends Enemy

func _follow_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
		
	if distance_from_target() < 4 * 16 :
		current_state = State.SCATTER
		return
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()
	
	
func _scatter_IA():
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		target = players[randi_range(0, players.size() - 1)]
		_on_recalculate_timer_timeout()
	
	if distance_from_target() > 6 * 16:
		current_state = State.FOLLOW
		return
	
	var direction : Vector2 = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()
	
	
func distance_from_target() -> float:
	if target == null:
		return 9999999
	
	var distance = (global_position - target.global_position).length()
	
	return distance
