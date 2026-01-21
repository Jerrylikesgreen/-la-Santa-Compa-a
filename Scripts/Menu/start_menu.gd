extends Control

@export var first_scene = "res://Scenes/black_scene.tscn"

@onready var option_menu = $OptionMenu

@onready var titulo = $Titulo
@onready var inicio = $Inicio

func _on_bot_continue_pressed() -> void:
	get_tree().change_scene_to_file(first_scene)


func _on_bot_new_game_pressed() -> void:
	get_tree().change_scene_to_file(first_scene)


func _on_bot_options_pressed() -> void:
	#if option_menu.is_visible():
		#option_menu.hide()
	#else: option_menu.show()

	titulo.hide()
	inicio.hide()

	option_menu.show()
	


func _on_bot_exit_pressed() -> void:
	get_tree().quit()
