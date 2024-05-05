extends Enemy

func _recalculate_position():
	if target ==  null:
		return
		
	var target_direction = target.global_position + target.velocity.normalized() * 2 * 16
	target_direction = target_direction - global_position
	var target_position = 2 * target_direction
	
	navigation_agent_2d.target_position = target_position
