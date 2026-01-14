class_name ClickingManager
extends Area2D

@onready var clicking_collision: CollisionShape2D = $ClickingCollision

var targets: Array = []

func _process(_delta: float) -> void:
	clicking_collision.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		for tree in targets:
			tree.hit()
			print(tree.name)

func _on_area_entered(area: Area2D) -> void:
	if area.owner is not TreeObject and area.is_in_group("trunk"):
		return
	targets.append(area.owner)

func _on_area_exited(area: Area2D) -> void:
	if area.owner is not TreeObject and area.is_in_group("trunk"):
		return
	targets.erase(area.owner)
