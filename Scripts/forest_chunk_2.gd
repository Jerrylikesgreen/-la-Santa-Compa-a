class_name ForestChunk2 extends ForestEnvChunk

func _ready() -> void:
	Signals.event_triggered.connect(_on_event_triggered)
	ui = 2
