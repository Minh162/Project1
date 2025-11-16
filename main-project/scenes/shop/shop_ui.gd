extends Control

@export var all_characters : Array[CharacterData]
@onready var items_container = $MarginContainer/Panel/ScrollContainer/HBoxContainer

func _ready():
	var scene = preload("res://scenes/shop/shop_item.tscn")
	for char_data in all_characters:
		var item = scene.instantiate()
		items_container.add_child(item)
		item.data = char_data
		item.add_to_group("shop_items")
		item.setup()
		item.reload_button_state.connect(refresh_buttons)

func refresh_buttons():
	get_tree().call_group("shop_items", "setup")
