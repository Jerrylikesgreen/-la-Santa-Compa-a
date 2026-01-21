extends Control
#extends CanvasLayer


@onready var titulo_menu = get_tree().get_nodes_in_group("titulo_menu")[0]
@onready var menu_base = get_tree().get_nodes_in_group("menu_base")[0]

@onready var sound_opt = $TextureRect/types_options/sound_opt
@onready var screen_opt = $TextureRect/types_options/screen_opt
@onready var control_opt = $TextureRect/types_options/control_opt
@onready var a11y_opt = $TextureRect/types_options/a11y_opt
@onready var actual_opt = sound_opt

func _ready() -> void:
	
	sound_opt.hide()
	screen_opt.hide()
	control_opt.hide()
	a11y_opt.hide()
	
	actual_opt.show()

func _on_sound_btn_pressed() -> void:
	actual_opt.hide()
	sound_opt.show()
	actual_opt = sound_opt
func _on_screen_btn_pressed() -> void:
	actual_opt.hide()
	screen_opt.show()
	actual_opt = screen_opt
func _on_control_btn_pressed() -> void:
	actual_opt.hide()
	control_opt.show()
	actual_opt = control_opt
func _on_a_11y_btn_pressed() -> void:
	actual_opt.hide()
	a11y_opt.show()
	actual_opt = a11y_opt

func _on_reset_option_btn_pressed() -> void:
	pass # Replace with function body.

func _on_exit_btn_pressed() -> void:
	hide()
	titulo_menu.show()
	menu_base.show()
