class_name UpgradeManager
extends Node

@export var clickingManager: ClickingManager
@export var treeSpawnManager: TreeSpawnManager

func _ready() -> void:
	Upgrades.clicker_damage.connect(on_clicker_damage)
	Upgrades.clicker_speed.connect(on_clicker_speed)
	Upgrades.planting_amount.connect(on_planting_amount)
	Upgrades.planting_speed.connect(on_planting_speed)

func on_clicker_damage(increase_amount: int) -> void:
	clickingManager.click_damage += increase_amount

func on_clicker_speed(increase_amount: float) -> void:
	clickingManager.click_cooldown = clickingManager.click_cooldown * (1 - increase_amount)
	clickingManager.click_cooldown = max(clickingManager.click_cooldown, 0.05)
	clickingManager.update_cooldown(clickingManager.click_cooldown)

func on_planting_speed(increase_amount: float) -> void:
	treeSpawnManager.tree_planting_cooldown = treeSpawnManager.tree_planting_cooldown * (1 - increase_amount)
	treeSpawnManager.tree_planting_cooldown = max(treeSpawnManager.tree_planting_cooldown, 0.5)
	treeSpawnManager.tree_spawn_timer.wait_time = treeSpawnManager.tree_planting_cooldown

func on_planting_amount(increase_amount: int) -> void:
	treeSpawnManager.plants_per_cooldown += increase_amount
