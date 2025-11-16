extends Panel

@export var data : CharacterData

@onready var icon: TextureRect = $MarginContainer/VBoxContainer/Icon
@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var price_label: Label = $MarginContainer/VBoxContainer/Price
@onready var health_label: Label = $MarginContainer/VBoxContainer/Health
@onready var damage_label: Label = $MarginContainer/VBoxContainer/Damage
@onready var speed_label: Label = $MarginContainer/VBoxContainer/Speed
@onready var button_buy: Button = $MarginContainer/VBoxContainer/ButtonBuy

signal reload_button_state

func setup() -> void:
	icon.texture = data.icon
	name_label.text = data.character_name
	health_label.text = "Health: " + str(data.max_health)
	damage_label.text = "Damage: " + str(data.damage)
	speed_label.text = "Speed: " + str(data.speed)
	price_label.text = "Price: " +  str(data.price) + " Coins"
	
	if data.character_id in SaveManager.purchased_characters:
		if data.character_id == SaveManager.selected_character:
			button_buy.text = "Selected"
		else:
			button_buy.text = "Select"
	else:
		button_buy.text = "Buy"

func _on_button_pressed():
	if data.character_id in SaveManager.purchased_characters:
		# chọn nhân vật
		SaveManager.selected_character = data.character_id
		SaveManager.save_data()
		button_buy.text = "Selected"
		get_tree().call_group("shop_items", "refresh_buttons")
	else:
		# mua nhân vật
		if SaveManager.coin >= data.price:
			SaveManager.coin -= data.price
			SaveManager.purchased_characters.append(data.character_id)

			SaveManager.selected_character = data.character_id
			SaveManager.save_data()

			button_buy.text = "Selected"
			get_tree().call_group("shop_items", "refresh_buttons")
		else:
			print("Không đủ coin!")
	reload_button_state.emit()
