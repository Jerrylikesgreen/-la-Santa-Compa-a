extends VBoxContainer



@export var language_csv_path = "res://Assets/Dialogues/language_CSV.csv"
@onready var ui_change = get_tree().get_nodes_in_group("tranlate_ui")

@onready var language = $language_dropdown

var ui_options = []

func _ready():
	ui_options = CD.load_csv(language_csv_path)
	
	
	_on_language_dropdown_dropdown_updated()
	
	
	
	
	
	
	
	
func change_ui_values():
	for i in ui_change:
		#i.ui_key
		for opt in ui_options:
			if opt.key == i.ui_key:
				i.change_value(opt)
				break
func _on_language_dropdown_dropdown_updated() -> void:
	#var a = language.indice
	#var e = language.claves
	#var ccc = language.claves[language.indice]
	CD.language_id = language.claves[language.indice]
	change_ui_values()
	pass # Replace with function body.

func _on_text_size_slider_slider_updated() -> void:
	pass # Replace with function body.

func _on_dyslexic_font_check_box_check_box_updated() -> void:
	pass # Replace with function body.


func _on_speed_auto_slider_slider_updated() -> void:
	pass # Replace with function body.
