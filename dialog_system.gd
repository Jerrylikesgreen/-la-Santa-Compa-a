extends CanvasLayer

## VARIABLES
# Export
@export var path_csv = "res://Assets/Dialogues/santa_compaña_dialgue_test.csv"
@export var languaje_key = "gl"
# OnReady
@onready var dialogue_text = $DialogContainer/VBoxContainer/TextOutputContainer/TextOutput
@onready var name_text = $SpeakerNameLabel
@onready var next_button = $DialogContainer/VBoxContainer/DialogOptions/NextButton
@onready var asp_talk = $AudioStreamPlayer2D
@onready var anim_controller = $AnimationPlayer
@onready var end_line_icon = $DialogContainer/VBoxContainer/EndLine
@onready var timer = $Timer
# Text
#var arr_dialogue = ["Hola","Antonio Recio!","Mayorista!","No limpio el pescado!"]
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
	
	start_dialogue.connect(func_inicio_dialogo)
	end_line.connect(func_end_line)
	
func _process(_delta):
	if !end:
		if fin_fade_in and (Input.is_action_just_pressed("Enter") or click_auto):
			
			click_auto = false
			anim_controller.play("idle")
			if writting:
				writting = false
				end_line.emit()
				dialogue_text.text = arr_dialogue[index_text - 1][languaje_key]
			else:
				# The CSV ended?
				if index_text >= arr_dialogue.size():
					anim_controller.play("fade_out")
					pass
				else:
					
					get_next_line()
				


# Extra

func func_inicio_dialogo():
	if auto_mode_normal: timer.start()
	load_csv(path_csv)
	get_next_line()
	fin_fade_in = true
func func_end_line():
	if auto_mode_normal: timer.start()
	anim_controller.play("end_line")
	
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
	var code = row["key"].split("-")
	match code[0]:
		"change_name":
			changue_voice(code[1],row[languaje_key])
		_:
			progressive_text(row[languaje_key])
			print(row[languaje_key])
	print(row)
	pass
func changue_voice(id,name_voice):
	name_text.text = name_voice
	
	match id:
		"manolo":
			asp_talk.stream = voice_00
		"customer":
			asp_talk.stream = voice_01
		_:
			asp_talk.stream = voice_missigno
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

func _on_timer_timeout() -> void:
	click_auto = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		start_dialogue.emit()
	elif anim_name == "fade_out":
		end_dialogue.emit()
		end = true
