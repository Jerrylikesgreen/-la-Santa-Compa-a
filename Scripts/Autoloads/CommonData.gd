extends Node

var auto_mode_normal = false

enum auto_mode_enum {NORMAL, AUTO_BASE, AUTO_WALK}
var auto_mode : auto_mode_enum
var player_camera: Camera2D
var player_movement = true
var moving
# Stores events triggerd inside its own scene. 
var events_trigered: Dictionary[int, int] 


func _ready():
	auto_mode = auto_mode_enum.NORMAL
	Signals.event_triggered.connect(_on_event_triggered)

func _process(_delta):
	#print(moving)
	pass

	
func start_dialogue(csv_path):
	pass

func _on_event_triggered(event_type: Signals.EventType, event_id: int, chuck_id: int) ->void:
	events_trigered[chuck_id] = event_id
	print(chuck_id, " Triggered ", event_id)
