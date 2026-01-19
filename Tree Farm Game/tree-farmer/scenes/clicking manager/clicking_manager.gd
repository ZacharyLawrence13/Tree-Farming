class_name ClickingManager
extends Area2D

@export var click_damage: int = 0
@export var click_cooldown: float = 0.5

@onready var clicking_collision: CollisionShape2D = $ClickingCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chop_cursor: Sprite2D = $ChopCursor
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var chop_cooldown_timer: Timer = $ChopCooldownTimer
@onready var cursor_progressbar: ProgressBar = $CursorControl/CursorProgressbar

var chop_cursor_texture: CompressedTexture2D = load("res://assets/graphics/cursors/resize_d_cross_diagonal.png")
var targets: Array[TreeObject] = []
var can_chop: bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	update_cooldown(click_cooldown)
	Events.tree_destroyed.connect(_on_tree_destroyed)
	Upgrades.clicker_damage.connect(upgrade_damage)
	Upgrades.clicker_speed.connect(upgrade_speed)

func upgrade_damage(amount: int) -> void:
	click_damage += amount

func upgrade_speed(amount: float) -> void:
	click_cooldown = click_cooldown * (1 - amount)
	click_cooldown = max(click_cooldown, 0.05)
	update_cooldown(click_cooldown)

func _process(_delta: float) -> void:
	position = get_global_mouse_position()
	if !chop_cooldown_timer.is_stopped():
		cursor_progressbar.value = click_cooldown - chop_cooldown_timer.time_left

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if can_chop:
			animation_player.current_animation = "click"
			hit_particles.restart()
			for tree in targets:
				tree.hit(click_damage)
			chop_cooldown_timer.start()
			can_chop = false

func check_empty_target() -> void:
	if targets.is_empty():
		chop_cursor.modulate = Color.WHITE

func update_cooldown(new_cooldown) -> void:
	click_cooldown = new_cooldown
	chop_cooldown_timer.wait_time = click_cooldown
	cursor_progressbar.max_value = click_cooldown
	print (cursor_progressbar.max_value)

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

func _on_chop_cooldown_timeout() -> void:
	can_chop = true
