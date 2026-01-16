extends Area2D

@onready var scene_dialogue = preload("res://Scenes/dialog_gui.tscn")
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test_short.csv"

func _on_body_entered(_body: Node2D) -> void:
	if _trigger_event():
		get_node("CollisionShape2D").disabled = true
		
		var dialog = scene_dialogue.instantiate()
		dialog.path_csv = path_csv
		get_tree().root.add_child(dialog)
		queue_free()


# left empty for sublass inharatence. 
func _trigger_event()->bool:
	return false
