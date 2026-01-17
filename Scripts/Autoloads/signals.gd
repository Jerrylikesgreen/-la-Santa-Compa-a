## Signals Autoload
extends Node

enum EventType {FOREST_EVENT}

signal event_triggered(event_type: EventType, event_id: int, chuck_id: int)
