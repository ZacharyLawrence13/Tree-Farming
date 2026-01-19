extends Node

signal clicker_damage(amount: int)
signal clicker_speed(amount: float)
signal planting_speed(amount: float)
signal planting_amount(amount: int)

func dummy() -> void:
	clicker_damage.emit()
	clicker_speed.emit()
	planting_speed.emit()
	planting_amount.emit()
