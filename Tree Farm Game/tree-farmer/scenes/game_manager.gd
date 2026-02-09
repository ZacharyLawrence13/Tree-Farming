extends Node

@onready var label_2: Label = $"../CanvasLayer/TopUI/HBoxContainer/Label2" #TODO temporary

func _ready() -> void:
	Events.tree_destroyed.connect(_on_tree_destroyed)

func _on_tree_destroyed(_tree: TreeObject) -> void:
	label_2.text = str(PlayerWood.gold_amount)
