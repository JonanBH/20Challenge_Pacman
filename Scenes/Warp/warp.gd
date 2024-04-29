extends Area2D
class_name Warp

@export var target : Warp

func _ready():
	$Sprite2D.hide()
	
	
func _on_body_entered(body):
	if target:
		target.teleport_player(body)


func teleport_player(body):
	
	await get_tree().create_timer(0.1).timeout
	call_deferred("_set_player_position", body)
	
	$Timer.start()


func _set_player_position(body):
	$CollisionShape2D.disabled = true
	body.global_position = self.global_position


func _on_timer_timeout():
	$CollisionShape2D.disabled = false
