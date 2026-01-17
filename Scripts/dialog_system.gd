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
@onready var spr_img = $Image
# Text
var arr_dialogue = []
var text_speed = 0.05
var index_text = 0
var writting = false
var fin_fade_in = false
# AutoMode
var click_auto = false
var end = false
var can_start_timer = false
# Signals
signal start_dialogue
signal end_line
signal end_dialogue
# Sound
const RANDOM_PITCH_MIN = 0.95
const RANDOM_PITCH_MAX = 1.05
# Char Img Path
const char_img_path = "res://Assets/Characters/PlaceHolder/"
const bkgr_img_path = "res://Assets/Background/"
# Path Sounds
const voice_missigno = preload("res://Assets/Sounds/sans_sound_placeholder.mp3")
const voice_00 = preload("res://Assets/Sounds/papyrus_sound_placeholder.mp3")
const voice_01 = preload("res://Assets/Sounds/undyne_sound_placeholder.mp3")
# Delete
var delete_after_end = true

## FUNC
# ready-process
func _ready():
	load_csv(path_csv)
	dialogue_text.text = ""
	CD.player_movement = false
	start_dialogue.connect(signal_inicio_dialogo)
	end_line.connect(signal_end_line)
func _process(_delta):
	if !end:
		
		# Stop timer if is auto mode walk and you are not walking
		if CD.auto_mode == CD.auto_mode_enum.AUTO_WALK and  timer.time_left > 0:
			if CD.moving: timer.paused = false
			else: timer.paused = true
			
		if fin_fade_in and \
			((Input.is_action_just_pressed("Enter") and !CD.auto_mode_normal) \
			or click_auto):
			
				click_auto = false
				anim_controller.play("idle")
				
				if writting:
					
					# If auto we return
					if CD.auto_mode_normal: return
					
					# Set variables/signal
					writting = false
					end_line.emit()
					
					# Set text
					dialogue_text.text = arr_dialogue[index_text - 1][languaje_key]
				
				else:
					
					# The CSV ended?
					#var aaaa = arr_dialogue.size()
					if index_text >= arr_dialogue.size()-1:
						anim_controller.play("fade_out")
					
					# Next line
					else:
						get_next_line()
	elif delete_after_end: 
		CD.player_movement = true
		queue_free()
# Signals
func signal_inicio_dialogo():
	if CD.auto_mode_normal: timer.start() #can_start_timer = true
	#timer.start()
	get_next_line()
	fin_fade_in = true
func signal_end_line():
	if CD.auto_mode_normal: timer.start() #can_start_timer = true
	#timer.start()
	anim_controller.play("end_line")
func _on_timer_timeout() -> void:
	can_start_timer = false
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
		# Change the img of the character
		"character_img":
			changue_char_img(code[1])
		# Change the background image
		"background_img":
			changue_background_img(code[1])
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
func changue_char_img(id):
	# We change the character sprite
	spr_img.texture = load(char_img_path+id+".png")
	# Process the next line
	get_next_line()
func changue_background_img(id):
	# We change the character sprite
	spr_img.texture = load(bkgr_img_path+id+".png")
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
