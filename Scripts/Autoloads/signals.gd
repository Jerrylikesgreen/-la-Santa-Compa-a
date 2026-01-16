## Signals Autoload
extends Node

enum EventType {FOREST_EVENT}

## PackedScene is menat to be refrence to the EventChunk that is triggering the event. 
signal event_triggered(event_type: EventType, event_id: int, chuck_id: int)
