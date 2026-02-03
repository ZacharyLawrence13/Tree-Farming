class_name TreePiece
extends RigidBody2D

@export var despawn_time: float = 2.0

@onready var despawn_timer: Timer = $DespawnTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var spawn_particles: GPUParticles2D = $SpawnParticles

const DESPAWN_TIME_VARIANCE: float = 1

func _ready() -> void:
	rotation_degrees = randi_range(-10, 10)
	despawn_timer.wait_time = randf_range(despawn_time - DESPAWN_TIME_VARIANCE, despawn_time + DESPAWN_TIME_VARIANCE)
	despawn_timer.start()
	spawn_particles.restart()

func _on_despawn_timer_timeout() -> void:
	animation_player.play("despawn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "despawn":
		queue_free()
