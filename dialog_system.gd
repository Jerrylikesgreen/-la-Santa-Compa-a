extends CanvasLayer

## VARIABLES
# Export
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test.csv"
@export var languaje_key = "gl"
# OnReady
@onready var dialogue_text = $DialogContainer/VBoxContainer/TextOutputContainer/TextOutput
@onready var name_text = $SpeakerNameLabel
@onready var next_button = $DialogContainer/VBoxContainer/DialogOptions/NextButton
# Text
#var arr_dialogue = ["Hola","Antonio Recio!","Mayorista!","No limpio el pescado!"]
var arr_dialogue = []
var text_speed = 0.05
var index_text = 0
var writting = false
# AutoMode
var auto_mode_normal = false
var auto_mode_walk = false

## FUNC
# ready-process
func _ready():
	load_csv(path_csv)
	get_next_line()

func _process(_delta):
	if Input.is_action_just_pressed("Enter"):
		if writting:
			writting = false
			dialogue_text.text = arr_dialogue[index_text-1][languaje_key]
		else:
			get_next_line()

# Extra
func load_csv(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ERROR WHEN ENTER THE CSV FILE")
		return

	var headers := []
	while not file.eof_reached():
		var line := file.get_line()
		if line.is_empty():
			continue

		var values := line.split(";")

		# Primera linea
		if headers.is_empty():
			headers = values
			continue

		var row := {}
		for i in range(headers.size()):
			row[headers[i]] = values[i]

		arr_dialogue.append(row)

	file.close()

func get_next_line():
	if index_text >= arr_dialogue.size():
		return

	var row = arr_dialogue[index_text]
	index_text += 1

	match row["key"]:
		"change_name":
			name_text.text = row[languaje_key]
			get_next_line()
		_:
			progressive_text(row[languaje_key])

func progressive_text(new_text):
	
	writting = true
	
	# We clear the previous string from the dialogue
	dialogue_text.text = ""
	
	# We add every character and wait x seconds to add the next
	for character in new_text:
		if !writting: break
		dialogue_text.text += character
		await get_tree().create_timer(text_speed).timeout

	
	writting = false
