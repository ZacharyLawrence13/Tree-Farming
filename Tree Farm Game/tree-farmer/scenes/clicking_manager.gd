class_name ClickingManager
extends Area2D

@export var click_damage: int = 0

@onready var clicking_collision: CollisionShape2D = $ClickingCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chop_cursor: Sprite2D = $ChopCursor

var chop_cursor_texture: CompressedTexture2D = load("res://assets/graphics/cursors/resize_d_cross_diagonal.png")
var targets: Array[TreeObject] = []

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.tree_destroyed.connect(_on_tree_destroyed)

func _process(_delta: float) -> void:
	clicking_collision.position = get_global_mouse_position()
	chop_cursor.position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		animation_player.current_animation = "click"
		for tree in targets:
			tree.hit(click_damage)
			print(tree.name)

func check_empty_target() -> void:
	if targets.is_empty():
		chop_cursor.modulate = Color.WHITE

func _on_area_entered(area: Area2D) -> void:
	if area.owner is not TreeObject and area.is_in_group("trunk"):
		return
	targets.append(area.owner)
	chop_cursor.modulate = Color.RED

func _on_area_exited(area: Area2D) -> void:
	if area.owner is not TreeObject and area.is_in_group("trunk"):
		return
	targets.erase(area.owner)
	check_empty_target()

func _on_tree_destroyed(tree: TreeObject):
	if tree in targets:
		targets.erase(tree)
	check_empty_target()
