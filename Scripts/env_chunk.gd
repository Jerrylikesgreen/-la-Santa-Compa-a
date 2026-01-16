class_name ForestEnvChunk extends Node2D


var events_trigered: Dictionary[int, int] 
var ui: int

func _ready() -> void:
	Signals.event_triggered.connect(_on_event_triggered)


func _on_event_triggered(event_type: Signals.EventType, event_id: int, chuck_id: int) ->void:
	if event_type == Signals.EventType.FOREST_EVENT and chuck_id == ui:
		events_trigered[chuck_id] = event_id
		print(events_trigered)
