extends CanvasLayer



@onready var titulo_menu = get_tree().get_nodes_in_group("titulo_menu")[0]
@onready var menu_base = get_tree().get_nodes_in_group("menu_base")[0]

func _on_button_pressed() -> void:
	hide()
	titulo_menu.show()
	menu_base.show()
