class_name DayCycleManager
extends Node2D

@onready var label: Label = $CanvasLayer/Control/Label

var current_day = 1

func start_new_day() -> void:
	current_day += 1
	update_day_ui()

func update_day_ui() -> void:
	label.text = "Day %d" % current_day
