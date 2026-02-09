class_name TreeObject
extends Node2D

@export var tree_data: TreeResource
@export var tree_piece: PackedScene
@export var tree_piece_scene: PackedScene

@onready var tree_sprite: Sprite2D = $TreeSprite
@onready var chopping_collision: CollisionShape2D = $TreeChoppingArea2D/ChoppingCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer # mostly for hit testing
@onready var tree_chopping_area_2d: Area2D = $TreeChoppingArea2D
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var destroy_sfx: AudioStreamPlayer2D = $DestroySFX
@onready var tree_gui: Control = $TreeGUI

const SFX_PITCH_SCALE_MIN: float = 0.7
const SFX_PITCH_SCALE_MAX: float = 1.3

var local_tree_piece_sprite_reference: CompressedTexture2D
var spawn_point: TreeSpawnPoint
var health: int

func _ready() -> void:
	set_tree_data()
	set_tree_gui()

func hit(hit_amount: int) -> void:
	animation_player.current_animation = "tree_hit"
	play_sfx()
	health -= hit_amount
	health = max(health, 0)
	tree_gui.update_health_gui(health)
	if health <= 0:
		if spawn_point:
			spawn_point.release(self)
		Events.tree_destroyed.emit(self)
		destroy_tree()

func cleanup_tree_death() -> void:
	destroy_sfx.play()
	tree_sprite.queue_free()
	tree_gui.queue_free()
	tree_chopping_area_2d.queue_free()

func destroy_tree() -> void:
	cleanup_tree_death()
	tree_sprite.hide()
	tree_gui.hide()
	tree_chopping_area_2d.monitorable = false
	tree_chopping_area_2d.monitoring = false
	var tree_size_y: float = tree_data.tree_texture.get_size().y
	var piece_count: int = tree_data.break_pieces
	var step: float = tree_size_y / piece_count
	
	for i in range(piece_count):
		var piece = tree_piece_scene.instantiate()
		var y_offset = (i + 0.5) * step
		piece.global_position = global_position + Vector2(0, -tree_size_y / 2 + y_offset)
		piece.get_node("Sprite2D").texture = local_tree_piece_sprite_reference
		add_child(piece)
	
	await get_tree().create_timer(2).timeout
	queue_free()

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
	destroy_sfx.stream = tree_data.tree_destroy_noise
	set_chopping_collision()
	health = tree_data.tree_health
	local_tree_piece_sprite_reference = tree_data.tree_piece_texture

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
