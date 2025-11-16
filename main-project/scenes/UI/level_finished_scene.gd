extends Control

@onready var coin_collected_label: Label = $CanvasGroup/CanvasGroup/Button/CoinCollectedLabel

func _process(_delta: float) -> void:
	coin_collected_label.text = "Coin collected: " + str(GameManager.collected_coin)

func _on_home_button_pressed() -> void:
	SceneChangingManager.load_menu()

func _on_level_scene_button_pressed() -> void:
	SceneChangingManager.load_level_choosing()
