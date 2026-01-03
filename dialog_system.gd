extends CanvasLayer

## VARIABLES
# OnReady
@onready var dialogue_text = $DialogContainer/VBoxContainer/TextOutputContainer/TextOutput
@onready var name_text = $SpeakerNameLabel
@onready var next_button = $DialogContainer/VBoxContainer/DialogOptions/NextButton
# Text
var arr_dialogue = ["Hola","Antonio Recio!","Mayorista!","No limpio el pescado!"]
var text_speed = 0.05
var index_text = 0
# AutoMode
var auto_mode_normal = false
var auto_mode_walk = false

## FUNC
# ready-process
func _ready():
	progressive_text(arr_dialogue[0])
func _process(_delta):
	if Input.is_action_just_pressed("Enter"):
		index_text += 1
		progressive_text(arr_dialogue[index_text])

# Extra
func progressive_text(new_text):
	
	# We clear the previous string from the dialogue
	dialogue_text.text = ""
	
	# We add every character and wait x seconds to add the next
	for character in new_text:
		dialogue_text.text += character
		await get_tree().create_timer(text_speed).timeout
