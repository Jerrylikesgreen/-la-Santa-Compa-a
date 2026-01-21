extends Control

#@onready var menu_main = get_tree().get_nodes_in_group("menu_main")[0]

@export var titulo = "Missigno"

@export var section_save : String
@export var key_save : String
@export var save_value_default : bool

@onready var label_titulo = $HBoxContainer/Label
@onready var check_box = $HBoxContainer/CheckBox

signal check_box_updated

var color_focus = Color(0.95,0.95,0.95,1.0)
var color_no_focus = Color(0.541,0.541,0.541,1.0)

func _ready():
	label_titulo.text = titulo

	check_box.toggled.connect(_on_check_box_value_changed)
	
	await get_tree().process_frame
	
	#cargar_check_box()
	
	_on_focus_exited()
	
func _on_check_box_value_changed(_toggle):
	guardar()
	check_box_updated.emit()
	
func guardar():
	CD.config.set_value(section_save, key_save, check_box.button_pressed)
	CD.save_data()
func cargar_check_box():
	var valor = CD.config.get_value(
		section_save, 
		key_save, 
		save_value_default)
	check_box.button_pressed = valor
	
func _on_mouse_entered() -> void:
	check_box.grab_focus()
	#menu_main.grab_focus_forzado(check_box)

func _on_h_box_container_mouse_entered() -> void:
	check_box.grab_focus()
	#menu_main.grab_focus_forzado(check_box)

func _on_focus_entered() -> void:
	label_titulo.add_theme_color_override("font_color", color_focus)

func _on_focus_exited() -> void:
	label_titulo.add_theme_color_override("font_color", color_no_focus)
