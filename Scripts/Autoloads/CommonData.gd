extends Node

var auto_mode_normal = false

enum auto_mode_enum {NORMAL, AUTO_BASE, AUTO_WALK}
var auto_mode : auto_mode_enum
var player_camera: Camera2D
var player_movement = true
var moving
func _ready():
	auto_mode = auto_mode_enum.NORMAL

func _process(_delta):
	#print(moving)
	pass
