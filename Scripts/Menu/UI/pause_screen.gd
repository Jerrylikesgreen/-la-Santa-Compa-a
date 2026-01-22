class_name PauseMenu
extends CanvasLayer

signal paused
signal unpaused

var is_paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


func toggle_pause() -> void:
	if is_paused:
		unpause()
	else:
		pause()


func pause() -> void:
	if is_paused:
		return

	is_paused = true
	get_tree().paused = true
	show()
	paused.emit()


func unpause() -> void:
	if not is_paused:
		return

	is_paused = false
	get_tree().paused = false
	hide()
	unpaused.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
