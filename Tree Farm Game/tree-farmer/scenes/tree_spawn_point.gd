class_name TreeSpawnPoint
extends Node2D

signal claimed(spawn_point: TreeSpawnPoint)
signal released(spawn_point: TreeSpawnPoint)

var occupying_tree: TreeObject = null

func is_occupied() -> bool:
	return occupying_tree != null

func claim(tree: TreeObject) -> void:
	if occupying_tree != null:
		return
	
	occupying_tree = tree
	emit_signal("claimed", self)

func release(tree: TreeObject) -> void:
	if occupying_tree != tree:
		return
	
	occupying_tree = null
	emit_signal("released", self)
