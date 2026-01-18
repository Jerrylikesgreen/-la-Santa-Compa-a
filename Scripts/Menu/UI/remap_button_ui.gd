extends Control
class_name RemapBotonUI

## VARIABLES
# Nombre Valor
@export var action_name : String = "mov_izq"

#@onready var menu_main = get_tree().get_nodes_in_group("menu_main")[0]

# Onreadies
@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button
# Secundario
var is_capturing: bool = false

var color_focus = Color(0.95,0.95,0.95,1.0)
var color_no_focus = Color(0.541,0.541,0.541,1.0)

var en_mismo_frame = false

## READY
func _ready():
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	
	set_process_unhandled_key_input(false)
	cambiar_nombre_label()
	#dar_nombre_boton()
	
	_on_focus_exited()

func _process(_delta):
	#if en_mismo_frame: 
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#await get_tree().process_frame
		#en_mismo_frame = false
		#print(en_mismo_frame)
	pass
## BASE
# Cuando el botón se presiona para reasignar
func _on_button_pressed():
	#menu_main.asignando_tecla = true
	if is_capturing:
		return # ya estamos capturando
	en_mismo_frame = true
	is_capturing = true
	button.text = "Pulsa una tecla..."
	set_process_unhandled_key_input(true)
	
	# Cerramos cualquier otro botón que esté capturando
	for i in get_tree().get_nodes_in_group("rebind_button"):
		if i != self and i.is_capturing:
			i._force_capture_off()
	pass
func _unhandled_key_input(event: InputEvent) -> void:
	if not is_capturing:
		return
	
	# En caso de que haga click el boton con el teclado
	# si es la primera vez, cancelara la accion
	if en_mismo_frame:
		en_mismo_frame = false
		return
	
	if event is InputEventKey:
		remapear_key(event)
	
	# Terminamos la captura
	_force_capture_off()
	
	# TODO: Realmente hacen fatla tanto sprocess frames? 
	# Esto es para que no se salga de ventana controles al pulsar esc
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	#menu_main.asignando_tecla = false
	
## CAMBIO TEXTO
func cambiar_nombre_label():
	label.text = "Missigno"
	match action_name:
		# Movimiento
		"mov_izq": label.text = "Movimineto Izquierda"
		"mov_der": label.text = "Movimiento Derecha"
		"mov_arr": label.text = "Movimiento Arriba"
		"mov_aba": label.text = "Movimiento Abajo"
		# Gravedad
		"grav_abajo": label.text = "Gravedad Abajo"
		"grav_arriba": label.text = "Gravedad Arriba"
		"grav_izq": label.text = "Gravedad Izquierda"
		"grav_der": label.text = "Gravedad Derecha"
		# UI
		"ui_arr": label.text = "UI Arriba"
		"ui_aba": label.text = "Ui Abajo"
		"ui_izq": label.text = "UI Izquierda"
		"ui_der": label.text = "Ui Derecha"
		"ui_aceptar": label.text = "UI Aceptar"
		# Extra
		"menu": label.text = "Menu"
		"puerta_aceptar": label.text = "Entrar Puerta"
		"salto_dash": label.text = "Salto/Dash"
func dar_nombre_boton():
	var acciones = InputMap.action_get_events(action_name)

	if acciones.is_empty():
		button.text = "Sin asignar"
		return
	
	# Busca preferentemente un InputEventKey
	var found_key: InputEventKey = null
	for a in acciones:
		if a is InputEventKey:
			found_key = a
			break

	if found_key:
		button.text = OS.get_keycode_string(found_key.physical_keycode)
		
	else:
		# Muestra primer binding disponible
		var first = acciones[0]
		if first is InputEventJoypadButton:
			button.text = "Botón mando %d" % first.button_index
		elif first is InputEventJoypadMotion:
			button.text = "Eje mando %d" % first.axis
		else:
			button.text = "Otro tipo de entrada"

## EXTRAS
# Desactiva la captura de este botón
func remapear_key(event):
	#print("\n--- Antes de modificar ---")
	#print(InputMap.action_get_events(action_name))
	#print("Evento recibido:", event)
	#print("Tipo:", event.get_class())

	if event is InputEventKey:
		var eventos = InputMap.action_get_events(action_name)
		
		# Borra solo eventos de teclado (mantiene mando/eje)
		for e in eventos:
			if e is InputEventKey:
				#print("Eliminando tecla:", OS.get_keycode_string(e.physical_keycode))
				InputMap.action_erase_event(action_name, e)
		
		# Añade la nueva tecla
		InputMap.action_add_event(action_name, event)
		
		#print("Añadiendo nueva tecla:", OS.get_keycode_string(event.physical_keycode))
		#print("--- Después de modificar ---")
		#print(InputMap.action_get_events(action_name))
		
		# Guardar datos
		#DatosComunes.config.set_value("Controlls", str(action_name), OS.get_keycode_string(event.physical_keycode))
		#DatosComunes.config.save(DatosComunes.SAVE_FILE_PATH)
		
		dar_nombre_boton()
	else:
		print("--- Evento no válido (no teclado) ---")
		print("Tipo:", event.get_class())
func _force_capture_off():
	if is_capturing:
		is_capturing = false
		set_process_unhandled_key_input(false)
		#menu_main.asignando_tecla = true
		dar_nombre_boton()


func _on_mouse_entered() -> void:
	button.grab_focus()
	#menu_main.grab_focus_forzado(button)

func _on_h_box_container_mouse_entered() -> void:
	button.grab_focus()
	#menu_main.grab_focus_forzado(button)


func _on_focus_entered() -> void:
	label.add_theme_color_override("font_color", color_focus)

func _on_focus_exited() -> void:
	label.add_theme_color_override("font_color", color_no_focus)
