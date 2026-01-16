class_name ForestEvent extends "res://Scripts/activador_dialogo.gd"


func _trigger_event()->void:
	## Grabs Chunk ID from Parent Node. 
	var chunk_id: int = get_parent().ui
	## Emits signal with Chunk ID along with Event type and Event ID. 
	Signals.event_triggered.emit(Signals.EventType.FOREST_EVENT, 1, chunk_id)
	print(self, " -> ",  chunk_id)
