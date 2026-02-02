extends Control

@onready var purchase_spawn_point_button: Button = $PurchaseSpawnPointButton

func show_buy_button() -> void:
	purchase_spawn_point_button.disabled = false
	show()

func hide_buy_button() -> void:
	purchase_spawn_point_button.disabled = true
	hide()

func update_button_price(new_price: int) -> void:
	purchase_spawn_point_button.text = str(new_price)
