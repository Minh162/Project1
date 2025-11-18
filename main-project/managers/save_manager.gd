extends Node

var save_path = "user://save.json"

# Player data
var coin : int = 0
var purchased_characters : Array = ["01"]   # contains character_id
var selected_character : String = ""        # character_id

# Audio settings
var sfx_volume : float = 1.0
var music_volume : float = 1.0

func _ready() -> void:
	load_data()
	apply_audio_settings()
	print("list purchased characters: " + str(purchased_characters))
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
		coin = 0
		purchased_characters = ["01"]
		selected_character = "01"
		sfx_volume = 1.0
		music_volume = 1.0
		save_data()
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) == TYPE_DICTIONARY:
		coin = data.get("coin", 0)
		purchased_characters = data.get("purchased_characters", ["01"])
		selected_character = data.get("selected_character", "01")
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

# -------------------
# Audio management
# -------------------

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)

	var bus_idx = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(sfx_volume))

	save_data()


func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)

	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(music_volume))

	save_data()

func apply_audio_settings():
	var sfx_bus = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))

	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))
