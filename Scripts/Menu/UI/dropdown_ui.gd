extends Control

#@onready var menu_main = get_tree().get_nodes_in_group("menu_main")[0]

@export var titulo = "Missigno"
@export_enum ("Por_Defecto","Idioma","Resolucion","Monitor") var tipo_dropdown = "Por_Defecto"
#@export(Enum(Opciones)) var mi_variable

@export var section_save : String
@export var key_save : String
@export var save_value_default : String = "en" # valor por defecto, clave

# Diccionario: clave = código, valor = idioma visible
@export var opciones = {
	"en": "English",
	"es": "Español",
	"gl": "Gallego"
}

var claves : Array = []
var indice : int = 0

@onready var titulo_label = $HBoxContainer/Label
@onready var valor_label = $HBoxContainer/Valor
@onready var bot_izq = $HBoxContainer/bot_izq
@onready var bot_der = $HBoxContainer/bot_der

signal dropdown_updated

var color_focus = Color(0.95,0.95,0.95,1.0)
var color_no_focus = Color(0.541,0.541,0.541,1.0)

var posibles_resoluciones = [
	# 4:3 y 5:4
	Vector2i(640, 480),
	Vector2i(800, 600),
	Vector2i(1024, 768),
	Vector2i(1280, 1024),
	# 16:10
	Vector2i(1280, 800),
	Vector2i(1440, 900),
	Vector2i(1680, 1050),
	Vector2i(1920, 1200),
	# 16:9
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
	# Ultrawide
	Vector2i(2560, 1080),
	Vector2i(3440, 1440),
	Vector2i(5120, 2160)]

func _ready():
	
	
	
	match tipo_dropdown:
		"Por_Defecto":
			pass
		#"Idioma":
			#obtener_idiomas()
		"Resolucion":
			obtener_resoluciones_validas()
		"Monitor":
			obtener_monitores()
	
	claves = opciones.keys()
	titulo_label.text = titulo
	cargar_dropdown_hipervitaminado()
	actualizar_texto()
	
	_on_focus_exited()

## CAMBIAR_OPCION
func cambiar_opcion(direccion: int) -> void:
	indice = (indice + direccion + claves.size()) % claves.size()
	actualizar_texto()
	guardar()
	
	dropdown_updated.emit()
func _input(event):
	if not (bot_izq.has_focus() or bot_der.has_focus()):
		return
	if event.is_action_pressed("ui_left"):
		cambiar_opcion(-1)
	elif event.is_action_pressed("ui_right"):
		cambiar_opcion(1)
func _on_bot_izq_pressed() -> void: cambiar_opcion(-1)
func _on_bot_der_pressed() -> void: cambiar_opcion(1)
func actualizar_texto():
	var clave
	#clave = claves[indice]
	if tipo_dropdown == "Resolucion":
		clave = opciones.values()[indice]
		valor_label.text = str(clave)
	else:
		clave = claves[indice]
		valor_label.text = str(opciones[clave])

## GRAB_FOCUS
func _on_mouse_entered(): 
	#menu_main.grab_focus_forzado(bot_izq)
	bot_izq.grab_focus()
func _on_h_box_container_mouse_entered(): 
	bot_izq.grab_focus()
	#menu_main.grab_focus_forzado(bot_izq)
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		grab_focus()  # hace que el HBoxContainer reciba foco
		#menu_main.grab_focus_forzado(self)
## GUARDAR / CARGAR
func guardar():
	var clave = claves[indice]
	CD.config.set_value(section_save, key_save, clave)
	CD.save_data()
	pass
func cargar_dropdown_hipervitaminado():
	var clave_guardada
	
	
	clave_guardada = CD.config.get_value(
		section_save,
		key_save,
		save_value_default
	)
#
	##if save_value_default == "none":
		##clave_guardada = DatosComunes.config.get_value(
			##section_save,
			##key_save,
			##save_value_default
		##)
	##else:
		##clave_guardada = DatosComunes.config.get_value(
			##section_save,
			##key_save,
			##save_value_default
		##)
		#
	if clave_guardada in claves:
		indice = claves.find(clave_guardada)
	else:
		indice = 0
	actualizar_texto()
	pass

## TIPO_DATOS
#func obtener_idiomas():
#
	#var file := FileAccess.open("res://assets/idiomas/traduccionAntroriaAlpha.csv", FileAccess.READ)
	#if file == null:
		#push_error("No se pudo abrir el archivo")
		#return []
	#
	#var lines := []
	#if not file.eof_reached():
		#lines.append(file.get_line().strip_edges()) # primera línea
	#if not file.eof_reached():
		#lines.append(file.get_line().strip_edges()) # segunda línea
	#
	#file.close()
	#
	#var headers = lines[0].split(",")
	#var values = lines[1].split(",")
#
	#opciones = {}
	#for i in range(1, headers.size()):
		#opciones[headers[i]] = values[i]
	#
	#print(opciones)
	#
func obtener_monitores():
	
	opciones = {}
	
	var total = DisplayServer.get_screen_count()
	
	#print("Cantidad de monitores:", total)
	#idioma
	for i in range(total):
		opciones[i] = i
		#var size = DisplayServer.screen_get_size(i)
		#print("Monitor ", i, ": resolución ", size)
func obtener_resoluciones_validas():
	
	var opciones_pre = {}
	#opciones = {}
	
	# Detecta el monitor actual
	var screen_index = DisplayServer.window_get_current_screen()
	var screen_size = DisplayServer.screen_get_size(screen_index)
	
	# Llena el array con las resoluciones válidas
	for res in posibles_resoluciones:
		if res.x <= screen_size.x and res.y <= screen_size.y:
			#resoluciones_arr.append(res)
			opciones_pre[res] = str(res.x) + " x " + str(res.y)
	
	#opciones.invert()
	
	
	var keys = opciones_pre.keys()
	# Invertir el array de claves
	keys.reverse()
#
	# Crear un nuevo diccionario invertido
	opciones = {}
	for key in keys:
		opciones[key] = opciones_pre[key]
	pass
	## DEBUGGING DE RESOLUCIONES
	#print("RESOLUCIONES PERMITIDAS")
	#for r in resoluciones_arr:
		#print(str(r.x)+" x "+str(r.y))


func _on_focus_entered() -> void:
	titulo_label.add_theme_color_override("font_color", color_focus)
	valor_label.add_theme_color_override("font_color", color_focus)

func _on_focus_exited() -> void:
	titulo_label.add_theme_color_override("font_color", color_no_focus)
	valor_label.add_theme_color_override("font_color", color_no_focus)
