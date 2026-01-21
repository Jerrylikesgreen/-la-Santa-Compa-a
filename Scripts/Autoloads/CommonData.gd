extends Node

var auto_mode_normal = false

enum auto_mode_enum {NORMAL, AUTO_BASE, AUTO_WALK}
var auto_mode : auto_mode_enum
var player_camera: Camera2D
var player_movement = true
var moving
# Stores events triggerd inside its own scene. 
var events_trigered: Dictionary[int, int] 

var language_id = "en"

const SAVE_FILE_PATH : String = "user://save_data.cfg"
var config = ConfigFile.new()

func _ready():
	config.load(SAVE_FILE_PATH)
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

func load_csv(path: String):
	
	# Try to get the file
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ERROR WHEN ENTER THE CSV FILE")
		return

	var arr_dialogue = []

	# Get values from CSV
	var headers := []
	while not file.eof_reached():
		
		# Check if exit loop
		var line := file.get_line()
		if line.is_empty():
			continue

		# Split line values from ;
		var values := line.split(";")

		# Check first line
		if headers.is_empty():
			headers = values
			continue

		# Appemd array
		var row := {}
		for i in range(headers.size()):
			row[headers[i]] = values[i]
		arr_dialogue.append(row)

	# Close CSV
	file.close()
	
	# Return CSV DATA
	return arr_dialogue

func save_data():
	config.save(SAVE_FILE_PATH)
