class_name ForestChunk1 extends ForestEnvChunk

func _ready() -> void:
	Signals.event_triggered.connect(_on_event_triggered)
	ui = 1
