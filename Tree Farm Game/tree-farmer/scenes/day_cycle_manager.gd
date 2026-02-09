class_name DayCycleManager
extends Node2D

@onready var label: Label = $CanvasLayer/Control/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var day_info_label: Label = $CanvasLayer/Control/DayInfoLabel

var current_day = 0

var day_info_message: String = "Day %d Ended..." % current_day

func _ready() -> void:
	start_new_day()

func start_new_day() -> void:
	animation_player.play("start_day")
	current_day += 1
	update_day_ui()

func end_current_day() -> void:
	animation_player.play("end_day")

func display_day_info() -> void:
	day_info_label.show()
	day_info_label.text = day_info_message
	await get_tree().create_timer(3).timeout
	day_info_label.hide()
	start_new_day()

func update_day_ui() -> void:
	label.text = "Day: %d" % current_day
	day_info_message = "Day %d Ended..." % current_day

func _on_end_day_button_pressed() -> void:
	end_current_day()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "end_day":
		display_day_info()
