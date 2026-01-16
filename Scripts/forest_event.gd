class_name ForestEvent extends "res://Scripts/activador_dialogo.gd"


func _trigger_event()->bool:
	
	## Grabs Chunk ID from Parent Node. 
	var chunk_id: int = get_parent().ui
	if CD.events_trigered.has(chunk_id) and CD.events_trigered[chunk_id] == 1:
		return false
	else:
		Signals.event_triggered.emit(Signals.EventType.FOREST_EVENT, 1, chunk_id)
		print(self, " -> ",  chunk_id)
		return true
	
