extends Control


@onready var music_slider: HSlider = $CanvasGroup/MusicSlider
@onready var sfx_slider: HSlider = $CanvasGroup/SFXSlider


func _on_button_back_pressed() -> void:
	SceneChangingManager.load_menu()


func _on_music_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value: float) -> void:
	pass # Replace with function body.
