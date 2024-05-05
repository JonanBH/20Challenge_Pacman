extends Node2D

@export var spawnables_layer : int = 2
@export var level_color : Color = Color.BLUE
@export var spawn_increments : Array[int]

@onready var coins = $Coins
@onready var tile_map = $NavigationRegion2D/TileMap
@onready var player = $Player
@onready var ghosts = $Ghosts
@onready var enemy_spawner = $EnemySpawner
@onready var player_starting_spot = $PlayerStartingSpot
@onready var unlock_play = $UnlockPlay



const COLECTABLE = preload("res://Scenes/Coin/colectable.tscn")
const POWER_PELLET = preload("res://Scenes/Coin/PowerPellet/power_pellet.tscn")

var remaining_dots = 0
var collected_dots = 0

func _ready():
	_prepare_spawnables()
	tile_map.set_layer_modulate(1, level_color)
	player.power_finished.connect(_power_finished)
	player.died.connect(_player_died)
	
	for enemy : Enemy in ghosts.get_children():
		enemy.died.connect(_enemy_died)
	
	reset_state()

func _spawn_dot(position : Vector2):
	print("Dot spawned at " + str(position))
	
	var new_dot = COLECTABLE.instantiate() as Colectable
	coins.add_child(new_dot)
	new_dot.position = position
	new_dot.colected.connect(_dot_colected)
	
	remaining_dots += 1


func _spawn_power_dot(position : Vector2):
	print("Power Pellet spawned at " + str(position))
	
	var new_dot = POWER_PELLET.instantiate() as Colectable
	coins.add_child(new_dot)
	new_dot.position = position
	new_dot.colected.connect(power_pellet_collected)
	
	remaining_dots += 1


func _spawn_player(position : Vector2):
	pass


func _prepare_spawnables():
	var cell_positions = tile_map.get_used_cells(spawnables_layer)
	
	for cell_position :Vector2i in cell_positions:
		var cell_atlas_coords = tile_map.get_cell_atlas_coords(spawnables_layer, cell_position)
		
		var actual_position = tile_map.map_to_local(cell_position)
		match cell_atlas_coords:
			Vector2i(0, 3):
				_spawn_dot(actual_position)
			Vector2i(1, 3):
				_spawn_power_dot(actual_position)
	tile_map.clear_layer(spawnables_layer)


func _dot_colected():
	remaining_dots -= 1
	collected_dots += 1
	
	if spawn_increments.has(collected_dots):
		enemy_spawner.increment_max_enemies_amount(1)
	
	if remaining_dots <= 0:
		get_tree().reload_current_scene()


func power_pellet_collected():
	_dot_colected()
	player.enable_power_dot()
	for child : Enemy in $Ghosts.get_children():
		child.begin_flee_from_pacman()


func _enemy_died(enemy):
	enemy_spawner.join_spawner(enemy)


func _power_finished():
	for enemy : Enemy in get_tree().get_nodes_in_group("spawned_enemy"):
		enemy.end_flee_from_pacman()


func _player_died():
	print("Player died")
	
	GameState.change_lives(-1)
	enemy_spawner.pause()
	
	for ghost:Enemy in ghosts.get_children():
		ghost.end_flee_from_pacman()
		ghost.current_position = ghost.global_position
		ghost.current_state = Enemy.State.IDLE
	
	if GameState.lives > 0:
		$ResetTimer.start()
		


func reset_state():
	player.global_position = player_starting_spot.global_position
	player.reset()
	
	enemy_spawner.reset()
	for ghost in ghosts.get_children():
		enemy_spawner.join_spawner(ghost)
	
	unlock_play.start()
	get_tree().paused = true


func _on_unlock_play_timeout():
	get_tree().paused = false
