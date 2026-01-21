extends VBoxContainer

var bus_master = AudioServer.get_bus_index("Master")
var bus_music = AudioServer.get_bus_index("Music")
var bus_sfx = AudioServer.get_bus_index("SFX")

@onready var master_slider = $master_slider
@onready var music_slider = $music_slider
@onready var effects_slider = $effects_slider

func _on_master_slider_slider_updated() -> void:
	AudioServer.set_bus_volume_db(bus_master,linear_to_db(master_slider.slider.value))
	
func _on_music_slider_slider_updated() -> void:
	AudioServer.set_bus_volume_db(bus_music,linear_to_db(music_slider.slider.value))
	
func _on_effects_slider_slider_updated() -> void:
	AudioServer.set_bus_volume_db(bus_sfx,linear_to_db(effects_slider.slider.value))
	
