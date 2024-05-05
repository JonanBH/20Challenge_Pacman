extends Node2D

@onready var spawn_spot = $SpawnSpot
@onready var holding_spots = $HoldingSpots
@onready var spawn_delay = $SpawnDelay

var enemies : Array[Enemy]
var spawned_enemies := 0
var max_spawnable_enemies := 1

func join_spawner(enemy : Enemy):
	enemy.current_state = Enemy.State.IDLE
	enemy.current_position = get_available_spot().global_position
	enemy.global_position = enemy.current_position
	enemies.append(enemy)
	enemy.remove_from_group("spawned_enemy")
	spawned_enemies = max(spawned_enemies - 1, 0)
	
	if enemies.size() > 0 and spawned_enemies < max_spawnable_enemies:
		spawn_delay.start()


func get_available_spot():
	return holding_spots.get_child(enemies.size())


func _on_spawn_delay_timeout():
	var enemy = enemies.pop_at(0)
	enemy.add_to_group("spawned_enemy")
	enemy.global_position = spawn_spot.global_position
	enemy.current_state = Enemy.State.FOLLOW
	spawned_enemies += 1
	_update_enemies_spots()
	
	if enemies.size() > 0 and spawned_enemies < max_spawnable_enemies:
		spawn_delay.start()


func increment_max_enemies_amount(amount : int):
	max_spawnable_enemies += amount
	if enemies.size() > 0 and spawned_enemies < max_spawnable_enemies and spawn_delay.is_stopped():
		spawn_delay.start()


func _update_enemies_spots():
	for index : int in range(0, enemies.size()):
		var spot = holding_spots.get_child(index)
		enemies[index].global_position = spot.global_position
		enemies[index].current_position = spot.global_position


func pause():
	spawn_delay.paused = true


func resume():
	spawn_delay.paused = false


func reset():
	spawned_enemies = 0
	spawn_delay.paused = false
	enemies.clear()
	spawn_delay.start()
