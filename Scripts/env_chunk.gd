class_name ForestEnvChunk extends Node2D


# Stores events triggerd inside its own scene. 
var events_trigered: Dictionary[int, int] 
# Left unassigned for subclass assignment. 
var ui: int

func _ready() -> void:
	Signals.event_triggered.connect(_on_event_triggered)

func _on_event_triggered(event_type: Signals.EventType, event_id: int, chuck_id: int) ->void:
	if event_type == Signals.EventType.FOREST_EVENT and chuck_id == ui:
		events_trigered[chuck_id] = event_id
		print(events_trigered)
