extends Control



func _on_damage_upgrade_pressed() -> void:
	Upgrades.clicker_damage.emit(2)


func _on_speed_upgrade_pressed() -> void:
	Upgrades.clicker_speed.emit(0.10)


func _on_plant_speed_upgrade_pressed() -> void:
	Upgrades.planting_speed.emit(0.10)


func _on_plant_amount_upgrade_pressed() -> void:
	Upgrades.planting_amount.emit(1)
