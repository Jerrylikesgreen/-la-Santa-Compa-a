extends Button

@export var ui_key = "AAAA"

func _ready():
	ui_key = text
	pressed.connect(_on_pressed)

func change_value(key):
	#print(key)
	text = key[CD.language_id]

func _on_pressed()->void:
	var nodes : Array[Node] =   get_tree().get_nodes_in_group("sfx_player")
	var sfx_player: SfxPlayer = nodes[0]
	sfx_player.play_track(SfxPlayer.SfxTrack.BUTTON)
