extends CanvasLayer

@export var first_scene = "res://Scenes/black_scene.tscn"

func _on_bot_continue_pressed() -> void:
	get_tree().change_scene_to_file(first_scene)


func _on_bot_new_game_pressed() -> void:
	get_tree().change_scene_to_file(first_scene)


func _on_bot_options_pressed() -> void:
	pass # Replace with function body.


func _on_bot_exit_pressed() -> void:
	get_tree().quit()
