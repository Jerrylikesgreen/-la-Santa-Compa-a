extends CanvasLayer

## VARIABLES
# OnReady
@onready var dialogue_text = $DialogContainer/VBoxContainer/TextOutputContainer/TextOutput
@onready var name_text = $SpeakerNameLabel
@onready var next_button = $DialogContainer/VBoxContainer/DialogOptions/NextButton
# Text
var arr_dialgos = []
var text_speed = 1
# AutoMode
var auto_mode_normal = false
var auto_mode_walk = false
