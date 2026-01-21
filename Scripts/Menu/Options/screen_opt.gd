extends Control

@onready var ruta_opciones = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer

#@onready var menu_main = get_tree().get_nodes_in_group("menu_main")[0]

#@onready var d_tipo_ventana = $scren_type_dropdown
@onready var fullscreeen_check_box = $full_screen_check_box
@onready var d_monitor = $screen_dropdown
@onready var d_resolucion = $resolution_dropdown

@onready var s_brillo = $brightness_slider
@onready var s_contraste = $contrast_slider
@onready var s_saturacion = $saturation_slider
# Botones
#@onready var bot_resetear = ruta_opciones.get_node("BotResetear")
# Scroll
@onready var scroll = $MarginContainer/VBoxContainer/ScrollContainer
#@onready var bot_focus = d_tipo_ventana.bot_izq
#@onready var bot_fin_scroll = bot_resetear

func _ready():
	
	await get_tree().process_frame
	
	fullscreeen_check_box.check_box_updated.connect(actualizar_tipo_ventana)
	d_monitor.dropdown_updated.connect(actualizar_monitor)
	d_resolucion.dropdown_updated.connect(actualizar_resolucion)
	
	# Crear un timer
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_comprobar_cambio_monitor)
	add_child(timer)
	
	
	s_brillo.slider_updated.connect(actualizar_brillo)
	s_contraste.slider_updated.connect(actualizar_contraste)
	s_saturacion.slider_updated.connect(actualizar_saturacion)
	
	actualizar_tipo_ventana()
	actualizar_monitor()
	actualizar_resolucion()
	
	actualizar_brillo()
	actualizar_contraste()
	actualizar_saturacion()
	
	#bot_focus.focus_entered.connect(_on_inicio_scroll_focus_entered)
	#bot_fin_scroll.focus_entered.connect(_on_final_scroll_focus_entered)
	
	
func actualizar_tipo_ventana():
	if fullscreeen_check_box.check_box.button_pressed:
		elegir_tipo_pantalla(false, false)
	else:
		elegir_tipo_pantalla(true, false)
		
func elegir_tipo_pantalla(ventana,bordes):
	
	if ventana: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,bordes)
func actualizar_monitor():
	DisplayServer.window_set_current_screen(d_monitor.claves[d_monitor.indice])
func actualizar_resolucion():
	#gamevariables[gamevariables.keys()[0]]
	#var aa = d_tipo_ventana.claves[d_tipo_ventana.indice]
	DisplayServer.window_set_size(d_resolucion.claves[d_resolucion.indice])
	
func actualizar_brillo():
	WE.environment.adjustment_brightness = s_brillo.slider.value
	pass
func actualizar_contraste():
	WE.environment.adjustment_contrast = s_contraste.slider.value
	pass
func actualizar_saturacion():
	WE.environment.adjustment_saturation = s_saturacion.slider.value
	pass

func _comprobar_cambio_monitor():
	var pantalla_actual = DisplayServer.window_get_current_screen()
	
	if pantalla_actual == int(d_monitor.indice):
		return
	
	d_monitor.indice = pantalla_actual
	
	d_resolucion.obtener_resoluciones_validas()
	d_resolucion.indice = 0
	
	d_monitor.guardar()
	d_resolucion.guardar()
	
	d_monitor.actualizar_texto()
	d_resolucion.actualizar_texto()

#func _on_inicio_scroll_focus_entered() -> void:
	#scroll.get_v_scroll_bar().value=scroll.get_v_scroll_bar().min_value
	#bot_focus.grab_focus()
	##menu_main.grab_focus_forzado(bot_focus)
#func _on_final_scroll_focus_entered() -> void:
	#scroll.get_v_scroll_bar().value=scroll.get_v_scroll_bar().max_value
	#bot_fin_scroll.grab_focus()
	##menu_main.grab_focus_forzado(bot_fin_scroll)


func _on_bot_resetear_pressed() -> void:
	d_monitor.indice = 0
	d_monitor.guardar()
	d_monitor.actualizar_texto()
	
	d_resolucion.indice = 0
	d_resolucion.guardar()
	d_resolucion.actualizar_texto()
	
	#d_tipo_ventana.indice = 0
	#d_tipo_ventana.guardar()
	#d_tipo_ventana.actualizar_texto()
	
	s_brillo.slider.value = 1
	s_contraste.slider.value = 1
	s_saturacion.slider.value = 1


#func _on_scren_type_dropdown_dropdown_updated() -> void:
	#pass # Replace with function body.
#func _on_screen_dropdown_dropdown_updated() -> void:
	#pass # Replace with function body.
#func _on_resolution_dropdown_dropdown_updated() -> void:
	#pass # Replace with function body.
#
#func _on_brightness_slider_slider_updated() -> void:
	#pass # Replace with function body.
#func _on_contrast_slider_slider_updated() -> void:
	#pass # Replace with function body.
#func _on_saturation_slider_slider_updated() -> void:
	#pass # Replace with function body.
