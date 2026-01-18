extends Node

signal tree_spawned(tree: TreeObject)
signal tree_destroyed(tree: TreeObject)

func dummy() -> void:
	tree_spawned.emit()
	tree_destroyed.emit()
