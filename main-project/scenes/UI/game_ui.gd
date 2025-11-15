extends CanvasLayer

@onready var coin_collected: Label = $CoinCollected

func _physics_process(_delta: float) -> void:
	coin_collected.text = "Coin: " + str(GameManager.collected_coin)

func _on_button_pressed() -> void:
	SceneChangingManager.load_menu()
	
