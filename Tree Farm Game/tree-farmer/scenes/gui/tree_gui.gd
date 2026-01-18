class_name TreeGUI
extends Control

@onready var health_label: Label = $HealthLabel

func update_health_gui(amount: int) -> void:
	var health_string = str(amount)
	health_label.text = health_string
