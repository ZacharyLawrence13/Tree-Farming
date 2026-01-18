class_name TreeSpawnManager
extends Node2D

@export var tree_type_resources: Array[TreeResource]
@export var tree_scene: PackedScene

@onready var tree_spawn_line: TreeSpawnLine = $TreeSpawnLine

func spawn_tree(amount: int):
	for _i in amount:
		var tree = tree_scene.instantiate()
		var tree_type = tree_type_resources.pick_random()
		tree.tree_data = tree_type
		tree.position = tree_spawn_line.get_tree_spawnpoint()
		add_child(tree)
		Events.tree_spawned.emit(tree)

func _on_tree_spawn_timer_timeout() -> void:
	spawn_tree(1)
