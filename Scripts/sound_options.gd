class_name SoundOptions
extends CanvasLayer

## UI
@onready var sfx_volume_slider: HSlider = %SfxVolumeSlider
@onready var main_volume_slider: HSlider = %MainVolumeSlider

## Audio buses
var master_bus := AudioServer.get_bus_index("Master")
var sfx_bus := AudioServer.get_bus_index("SFX")


func _ready() -> void:
	# Sync sliders with current bus volumes
	main_volume_slider.value = AudioServer.get_bus_volume_db(master_bus)
	sfx_volume_slider.value = AudioServer.get_bus_volume_db(sfx_bus)

	# Connect signals
	main_volume_slider.value_changed.connect(_on_master_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)


func _on_master_volume_changed(value: float) -> void:
	_apply_volume(master_bus, value, -60.0)


func _on_sfx_volume_changed(value: float) -> void:
	_apply_volume(sfx_bus, value, -40.0)


func _apply_volume(bus: int, value: float, mute_threshold: float) -> void:
	if value <= mute_threshold:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, value)
