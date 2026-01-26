extends GPUParticles2D

@onready var sprite_pivot: Node2D = $SpritePivot

func _ready() -> void:
	sprite_pivot.rotation_degrees = randi_range(0, 360)

func _on_finished() -> void:
	queue_free()
