extends Enemy

func _recalculate_position():
	if target == null:
		return
	
	var target_position = target.global_position + target.velocity.normalized() * 4  * 16
	navigation_agent_2d.target_position = target_position
