extends Control


@onready var music_slider: HSlider = $CanvasGroup/MusicSlider
@onready var sfx_slider: HSlider = $CanvasGroup/SFXSlider


func _ready() -> void:
	music_slider.value = SaveManager.music_volume
	sfx_slider.value = SaveManager.sfx_volume


func _on_button_back_pressed() -> void:
	SceneChangingManager.load_menu()


func _on_music_slider_value_changed(value: float) -> void:
	SaveManager.set_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SaveManager.set_sfx_volume(value)
