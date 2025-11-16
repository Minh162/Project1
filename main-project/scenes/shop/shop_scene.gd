extends Control

@onready var coin_label: Label = $CanvasGroup/CoinLabel

func _process(_delta: float) -> void:
	coin_label.text = "Coin: " + str(SaveManager.coin)

func _on_button_back_pressed() -> void:
	SceneChangingManager.load_menu()
