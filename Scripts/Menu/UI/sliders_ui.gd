extends Control

@export var titulo = "Missigno"
@export var porcentaje : bool

@export var section_save : String
@export var key_save : String
@export var save_value_default : int

@export var val_min: float = 0
@export var val_max: float = 1
@export var val_step: float = 0.1

@onready var label_titulo = $HBoxContainer/Label
@onready var slider = $HBoxContainer/Slider
@onready var label_valor = $HBoxContainer/Valor

@onready var menu_main = get_tree().get_nodes_in_group("menu_main")[0]

signal slider_actualizado

var color_focus = Color(0.281, 0.281, 0.281, 1.0)
var color_no_focus = Color(0.541,0.541,0.541,1.0)

func _ready():
	label_titulo.text = titulo
	
	slider.min_value = val_min
	slider.max_value = val_max
	slider.step = val_step
	
	slider.value_changed.connect(_on_slider_value_changed)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	cargar_slider()
	
	_on_focus_exited()
	
func _on_slider_value_changed(value):
	
	if porcentaje:
		label_valor.text = str(value*100)+"%"
	else:
		label_valor.text = str(value)
		
	guardar()
	
	slider_actualizado.emit()

func guardar():
	#CD.config.set_value(section_save, key_save, slider.value)
	#CD.config.save(DatosComunes.SAVE_FILE_PATH)
	pass
	
func cargar_slider():
	#var valor = DatosComunes.config.get_value(
		#section_save, 
		#key_save, 
		#save_value_default)
	#slider.value = valor
	#label_valor.text = str(valor*100)+"%"
	pass

func _on_mouse_entered() -> void:
	slider.grab_focus()
	#menu_main.grab_focus_forzado(slider)

func _on_h_box_container_mouse_entered() -> void:
	slider.grab_focus()
	#menu_main.grab_focus_forzado(slider)

func _on_focus_entered() -> void:
	label_titulo.add_theme_color_override("font_color", color_focus)
	label_valor.add_theme_color_override("font_color", color_focus)

func _on_focus_exited() -> void:
	label_titulo.add_theme_color_override("font_color", color_no_focus)
	label_valor.add_theme_color_override("font_color", color_no_focus)
