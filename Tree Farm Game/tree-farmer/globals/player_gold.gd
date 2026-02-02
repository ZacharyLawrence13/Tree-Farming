extends Node

var gold_amount: int = 0

func _ready() -> void:
	Events.tree_destroyed.connect(_on_tree_destroyed)

func add_gold(add_amount) -> void:
	gold_amount += add_amount

func subtract_gold(sub_amount) -> void:
	gold_amount -= sub_amount

func _on_tree_destroyed(tree: TreeObject) -> void:
	add_gold(tree.tree_data.tree_value)
