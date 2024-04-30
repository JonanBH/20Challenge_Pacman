extends Node2D

@export var spawnables_layer : int = 2
@export var level_color : Color = Color.BLUE

@onready var coins = $Coins
@onready var tile_map = $NavigationRegion2D/TileMap

const COLECTABLE = preload("res://Scenes/Coin/colectable.tscn")
const POWER_PELLET = preload("res://Scenes/Coin/PowerPellet/power_pellet.tscn")

var remaining_dots = 0

func _ready():
	_prepare_spawnables()
	tile_map.set_layer_modulate(1, level_color)
	

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
	new_dot.colected.connect(_dot_colected)
	
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
	if remaining_dots <= 0:
		print("Victory")
