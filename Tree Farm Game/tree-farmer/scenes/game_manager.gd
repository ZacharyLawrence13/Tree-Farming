extends Node

var dollar_amount: int
@onready var label_2: Label = $"../CanvasLayer/TopUI/HBoxContainer/Label2" #TODO temporary

func _ready() -> void:
	Events.tree_destroyed.connect(_on_tree_destroyed)

func _on_tree_destroyed(tree: TreeObject) -> void:
	dollar_amount += tree.tree_data.tree_value
	label_2.text = str(dollar_amount)
