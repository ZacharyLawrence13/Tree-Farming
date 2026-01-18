class_name TreeSpawnLine
extends Line2D


func get_tree_spawnpoint() -> Vector2:
	return get_point_position(randi_range(1, get_point_count()))
