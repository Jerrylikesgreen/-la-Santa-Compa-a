extends Area2D

@onready var scene_dialogue = preload("res://Scenes/dialog_gui.tscn")
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test_short.csv"

func _on_body_entered(body: Node2D) -> void:
	print("BBBBBBBBBBBBBBBBbbbb")
	get_node("CollisionShape2D").disabled = true
	#var puntos = tablero_obj.puntoMovimiento.instantiate()
	#puntos.tipo_tablero = tablero_obj.id_tablero
	#tablero_obj.cajaPuntos.add_child(puntos)

	var dialog = scene_dialogue.instantiate()
	dialog.path_csv = path_csv
	add_child(dialog)
