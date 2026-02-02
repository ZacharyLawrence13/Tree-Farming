extends Node

signal purchased_spawn_point(spawn_point: TreeSpawnPoint)

signal tree_spawned(tree: TreeObject)
signal tree_destroyed(tree: TreeObject)

func dummy() -> void:
	purchased_spawn_point.emit()
	tree_spawned.emit()
	tree_destroyed.emit()
