class_name TreeSpawnManager
extends Node2D

@export var tree_type_resources: Array[TreeResource]
@export var tree_scene: PackedScene

@onready var tree_spawner: TreeSpawner = $TreeSpawner
@onready var tree_spawn_timer: Timer = $TreeSpawnTimer

var plants_per_cooldown: int = 1
var tree_planting_cooldown: float = 3.0

func _ready() -> void:
	tree_spawn_timer.wait_time = tree_planting_cooldown
	Upgrades.planting_speed.connect(upgrade_tree_planting_cooldown)
	Upgrades.planting_amount.connect(upgrade_planting_amount)

func upgrade_planting_amount(amount: int):
	plants_per_cooldown += amount

func upgrade_tree_planting_cooldown(amount: float):
	tree_planting_cooldown = tree_planting_cooldown * (1 - amount)
	tree_planting_cooldown = max(tree_planting_cooldown, 0.5)
	tree_spawn_timer.wait_time = tree_planting_cooldown

func spawn_tree(amount: int):
	for _i in amount:
		var spawn_point: TreeSpawnPoint = tree_spawner.get_valid_spawn_point()
		if spawn_point == null:
			return
		
		var tree: TreeObject = tree_scene.instantiate()
		var tree_type: TreeResource = tree_type_resources.pick_random()
		tree.tree_data = tree_type
		tree.spawn_point = spawn_point
		tree.global_position = spawn_point.global_position
		add_child(tree)
		spawn_point.claim(tree)
		Events.tree_spawned.emit(tree)

func _on_tree_spawn_timer_timeout() -> void:
	spawn_tree(plants_per_cooldown)
