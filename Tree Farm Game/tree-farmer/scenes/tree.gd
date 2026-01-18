class_name TreeObject
extends Node2D

@export var tree_data: TreeResource

@onready var tree_sprite: Sprite2D = $TreeSprite
@onready var chopping_collision: CollisionShape2D = $TreeChoppingArea2D/ChoppingCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer # mostly for hit testing
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var tree_gui: Control = $TreeGUI

const SFX_PITCH_SCALE_MIN: float = 0.7
const SFX_PITCH_SCALE_MAX: float = 1.3

var health: int

func _ready() -> void:
	set_tree_data()
	set_tree_gui()

func hit(hit_amount: int) -> void:
	animation_player.current_animation = "tree_hit"
	play_sfx()
	health -= hit_amount
	tree_gui.update_health_gui(health)
	if health <= 0:
		Events.tree_destroyed.emit(self)
		call_deferred("queue_free")


#region Apply Juice
func play_sfx() -> void:
	hit_sfx.pitch_scale = randf_range(SFX_PITCH_SCALE_MIN, SFX_PITCH_SCALE_MAX)
	hit_sfx.play()
#endregion
#region Setting Tree Data                                                                                          
func set_tree_data() -> void:
	tree_data = tree_data.duplicate()
	tree_sprite.offset = Vector2(tree_data.tree_texture.get_size().x / -2, tree_data.tree_texture.get_size().y * -1)
	tree_sprite.texture = tree_data.tree_texture
	hit_sfx.stream = tree_data.tree_hit_noise
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
#region Setting Tree GUI
func set_tree_gui() -> void:
	tree_gui.update_health_gui(health)
#endregion
