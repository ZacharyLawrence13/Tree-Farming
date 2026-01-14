class_name TreeObject
extends Node2D

@export var tree_data: TreeResource

@onready var tree_sprite: Sprite2D = $TreeSprite
@onready var chopping_collision: CollisionShape2D = $TreeChoppingArea2D/ChoppingCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer # mostly for hit testing

var health: int

func _ready() -> void:
	set_tree_data()

func hit() -> void:
	animation_player.current_animation = "tree_hit"

#region Setting Tree Data
func set_tree_data() -> void:
	tree_sprite.offset = Vector2(tree_data.tree_texture.get_size().x / -2, tree_data.tree_texture.get_size().y * -1)
	tree_sprite.texture = tree_data.tree_texture
	set_chopping_collision()
	health = tree_data.tree_health

func set_chopping_collision() -> void:
	if not tree_sprite.texture:
		return
	
	var shape := RectangleShape2D.new()
	
	shape.size = Vector2(tree_data.trunk_width, tree_data.trunk_height)
	chopping_collision.shape = shape
	chopping_collision.position.y -= tree_data.trunk_height * 0.5
#endregion
