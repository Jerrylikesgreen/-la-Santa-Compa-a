class_name ForestEnvChunk extends Node2D


# Stores events triggerd inside its own scene.  Key = Chunk id Value = Event Id
var events_trigered: Dictionary[int, int] 
# Left unassigned for subclass assignment. 
@export var ui: int

func _ready() -> void:
	Signals.event_triggered.connect(_on_event_triggered)
	events_trigered = CD.events_trigered

func _on_event_triggered(event_type: Signals.EventType, event_id: int, chuck_id: int) ->void:
	if events_trigered.get(chuck_id) == event_id:
		return

		
	if event_type == Signals.EventType.FOREST_EVENT and chuck_id == ui:
		events_trigered[chuck_id] = event_id
