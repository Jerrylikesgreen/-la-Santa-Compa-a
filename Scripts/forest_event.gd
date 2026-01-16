
class_name ForestEvent extends "res://Scripts/activador_dialogo.gd"


func _trigger_event()->void:
	var chuck_id: int = get_parent().ui
	Signals.event_triggered.emit(Signals.EventType.FOREST_EVENT, 1, chuck_id)
	print(self, " -> ",  chuck_id)
