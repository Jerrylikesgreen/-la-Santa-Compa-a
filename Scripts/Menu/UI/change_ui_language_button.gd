extends Button

@export var ui_key = "AAAA"

func _ready():
	ui_key = text
	pass
func change_value(key):
	#print(key)
	text = key[CD.language_id]
