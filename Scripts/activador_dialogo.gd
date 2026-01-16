extends Area2D

@onready var scene_dialogue = preload("res://Scenes/dialog_gui.tscn")
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test_short.csv"

func _on_body_entered(_body: Node2D) -> void:
	get_node("CollisionShape2D").disabled = true
	
	var dialog = scene_dialogue.instantiate()
	dialog.path_csv = path_csv
	get_tree().root.add_child(dialog)
	_trigger_event()
	queue_free()


func _trigger_event()->void:
	pass
