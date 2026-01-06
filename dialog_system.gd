extends CanvasLayer

## VARIABLES
# Export
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test.csv"
@export var languaje_key = "gl"
# OnReady
@onready var dialogue_text = $DialogContainer/TextOutput
@onready var name_text = $SpeakerNameLabel
@onready var asp_talk = $AudioStreamPlayer2D
@onready var anim_controller = $AnimationPlayer
@onready var anim_name_box = $AnimName
@onready var end_line_icon = $DialogContainer/EndLine
@onready var timer = $Timer
# Text
var arr_dialogue = []
var text_speed = 0.05
var index_text = 0
var writting = false
var fin_fade_in = false
# AutoMode
var click_auto = false
var end = false
var auto_mode_normal = true
var auto_mode_walk = false
# Signals
signal start_dialogue
signal end_line
signal end_dialogue
# Sound
const RANDOM_PITCH_MIN = 0.95
const RANDOM_PITCH_MAX = 1.05
# Path Sounds
const voice_missigno = preload("res://Assets/Sounds/sans_sound_placeholder.mp3")
const voice_00 = preload("res://Assets/Sounds/papyrus_sound_placeholder.mp3")
const voice_01 = preload("res://Assets/Sounds/undyne_sound_placeholder.mp3")

## FUNC
# ready-process
func _ready():
	load_csv(path_csv)
	dialogue_text.text = ""
	start_dialogue.connect(signal_inicio_dialogo)
	end_line.connect(signal_end_line)
func _process(_delta):
	if !end:
		
		if fin_fade_in and \
			((Input.is_action_just_pressed("Enter") and !auto_mode_normal) \
			or click_auto):
			
				click_auto = false
				anim_controller.play("idle")
				
				if writting:
					
					# If auto we return
					if auto_mode_normal: return
					
					# Set variables/signal
					writting = false
					end_line.emit()
					
					# Set text
					dialogue_text.text = arr_dialogue[index_text - 1][languaje_key]
				
				else:
					
					# The CSV ended?
					if index_text >= arr_dialogue.size():
						anim_controller.play("fade_out")
					
					# Next line
					else:
						get_next_line()

# Signals
func signal_inicio_dialogo():
	if auto_mode_normal: timer.start()
	get_next_line()
	fin_fade_in = true
func signal_end_line():
	if auto_mode_normal: timer.start()
	anim_controller.play("end_line")
func _on_timer_timeout() -> void:
	click_auto = true
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		start_dialogue.emit()
	elif anim_name == "fade_out":
		end_dialogue.emit()
		end = true

# Extra
func load_csv(path: String) -> void:
	
	# Try to get the file
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ERROR WHEN ENTER THE CSV FILE")
		return

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
func get_next_line():
	
	# If we ended the text we return function
	if index_text >= arr_dialogue.size():
		return
	
	# Get the next value
	index_text += 1
	
	# Check if line is a code and id
	var row = arr_dialogue[index_text]
	var code = row["key"].split("-")
	match code[0]:
		# Change the text name
		"change_name":
			changue_voice(code[1],row[languaje_key])
		# No Code
		_:
			progressive_text(row[languaje_key])
func changue_voice(id,name_voice):
	
	# We turn on the name box
	if name_text.text == "no_name":
		anim_name_box.play("show_name")
	
	# We set te name text
	name_text.text = name_voice
	
	# We change te text sound
	match id:
		"manolo":
			asp_talk.stream = voice_00
		"customer":
			asp_talk.stream = voice_01
		_:
			asp_talk.stream = voice_missigno
			
	# Process the next line
	get_next_line()
func progressive_text(new_text):
	
	writting = true
	
	# We clear the previous string from the dialogue
	dialogue_text.text = ""
	
	# We add every character and wait x seconds to add the next
	for character in new_text:
		if !writting: break
		dialogue_text.text += character
		asp_talk.play()
		asp_talk.pitch_scale = randf_range(RANDOM_PITCH_MIN, RANDOM_PITCH_MAX)
		await get_tree().create_timer(text_speed).timeout

	end_line.emit()
	writting = false
