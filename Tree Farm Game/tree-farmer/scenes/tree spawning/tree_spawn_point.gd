class_name TreeSpawnPoint
extends Node2D

signal claimed(spawn_point: TreeSpawnPoint)
signal released(spawn_point: TreeSpawnPoint)

@export var is_active: bool = false

@onready var tree_spawn_point_gui: Control = $TreeSpawnPointGUI

var spawn_point_cost: int = 1
var occupying_tree: TreeObject = null

func _ready() -> void:
	if is_active:
		tree_spawn_point_gui.hide_buy_button()
	
	Events.purchased_spawn_point.connect(_on_purchased_spawn_point)

func activate_spawn_point() -> void:
	if PlayerGold.gold_amount >= spawn_point_cost:
		is_active = true
		tree_spawn_point_gui.hide_buy_button()
		PlayerGold.subtract_gold(spawn_point_cost)
		Events.purchased_spawn_point.emit(self)

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

func _on_purchased_spawn_point(spawn_point: TreeSpawnPoint) -> void:
	spawn_point_cost *= 2
	tree_spawn_point_gui.update_button_price(spawn_point_cost)
