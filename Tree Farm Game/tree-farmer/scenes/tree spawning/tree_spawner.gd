class_name TreeSpawner
extends Node2D

var all_spawn_points: Array[TreeSpawnPoint] = []
var valid_spawn_points: Array[TreeSpawnPoint] = []

func _ready() -> void:
	for child in get_children():
		if child is TreeSpawnPoint:
			all_spawn_points.append(child)
			if child.is_active:
				valid_spawn_points.append(child)
			
			child.claimed.connect(_on_spawn_point_claimed)
			child.released.connect(_on_spawn_point_released)
	
	Events.purchased_spawn_point.connect(add_valid_spawn_point)

func add_valid_spawn_point(spawn_point: TreeSpawnPoint) -> void:
	valid_spawn_points.append(spawn_point)

func _on_spawn_point_claimed(spawn_point: TreeSpawnPoint) -> void:
	valid_spawn_points.erase(spawn_point)

func _on_spawn_point_released(spawn_point: TreeSpawnPoint) -> void:
	if spawn_point not in valid_spawn_points:
		valid_spawn_points.append(spawn_point)

func get_valid_spawn_point() -> TreeSpawnPoint:
	if valid_spawn_points.is_empty():
		return null
	
	return valid_spawn_points.pick_random()
