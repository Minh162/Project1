extends Node

var save_path = "user://save.json"

# Player data
var coin : int = 0
var purchased_characters : Array = ["01"]   # contains character_id
var selected_character : String = ""        # character_id

# Audio settings
var sfx_volume : float = 1.0   # 0.0 - 1.0
var music_volume : float = 1.0 # 0.0 - 1.0

func _ready() -> void:
	load_data()
	print("Selected character:", selected_character)
	print("Coins:", coin)
	print("SFX volume:", sfx_volume, "Music volume:", music_volume)


# -------------------
# Data saving/loading
# -------------------

func save_data():
	var data = {
		"coin": coin,
		"purchased_characters": purchased_characters,
		"selected_character": selected_character,
		"sfx_volume": sfx_volume,
		"music_volume": music_volume
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	print("Data saved.")


func load_data():
	if not FileAccess.file_exists(save_path):
		save_data()
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) == TYPE_DICTIONARY:
		coin = data.get("coin", 0)
		purchased_characters = data.get("purchased_characters", ["01"])
		selected_character = data.get("selected_character", "")
		sfx_volume = data.get("sfx_volume", 1.0)
		music_volume = data.get("music_volume", 1.0)
		print("Data loaded.")


# -------------------
# Coin management
# -------------------

# Add coins after finishing level
func add_coins(amount: int):
	coin += amount
	print("Added", amount, "coins. Total:", coin)
	save_data()

# Spend coins to buy character
# Returns true if purchase successful
func spend_coins(amount: int) -> bool:
	if coin >= amount:
		coin -= amount
		print("Spent", amount, "coins. Remaining:", coin)
		save_data()
		return true
	else:
		print("Not enough coins!")
		return false

# -------------------
# Character management
# -------------------

# Purchase a character
func buy_character(character_id: String, price: int) -> bool:
	if character_id in purchased_characters:
		print("Character already purchased.")
		return false

	if spend_coins(price):
		purchased_characters.append(character_id)
		print("Purchased character:", character_id)
		save_data()
		return true
	return false

# Select a character
func select_character(character_id: String):
	if character_id in purchased_characters:
		selected_character = character_id
		print("Selected character:", character_id)
		save_data()
	else:
		print("Character not owned!")


# -------------------
# Audio management
# -------------------

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	save_data()
	print("SFX volume set to:", sfx_volume)

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	save_data()
	print("Music volume set to:", music_volume)
