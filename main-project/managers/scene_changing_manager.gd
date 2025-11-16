extends Node

#SceneManager.change_scene(
  #'res://demo/test2.tscn',
  #{ "pattern": "scribbles", "pattern_leave": "squares" }
#)

var menu_scene : String = "res://scenes/UI/menu_scene.tscn"
var setting_scene: String = "res://scenes/UI/setting_scene.tscn"
var level_choosing_scene: String = "res://scenes/UI/level_choosing_scene.tscn"
var level_failed_scene: String = "res://scenes/UI/level_failed.tscn"
var level_finished_scene: String = "res://scenes/UI/level_finished.tscn"
var shop_scene : String = "res://scenes/shop/shop_scene.tscn"

func load_level(level_number: int):
	GameManager.current_level = "level0" + str(level_number)
	GameManager.start_new_game()
	SceneManager.change_scene(
		"res://scenes/level_0" + str(level_number) + ".tscn",
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_menu():
	SceneManager.change_scene(
		menu_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_setting():
	SceneManager.change_scene(
		setting_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_level_choosing():
	SceneManager.change_scene(
		level_choosing_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_level_finished():
	SceneManager.change_scene(
		level_finished_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_level_failed():
	SceneManager.change_scene(
		level_failed_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)

func load_shop():
	SceneManager.change_scene(
		shop_scene,
		{ "pattern": "scribbles", "pattern_leave": "squares" }
	)
