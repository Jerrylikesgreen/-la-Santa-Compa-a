extends AnimationPlayer

enum enum_scene {MOTHER,LOOP,OLDMAN}
@export var scene_type : enum_scene

@onready var dialogue = $DialogGui
@onready var player = $Player

func _ready():
	dialogue.anim_controller.play("hide_dialogue")
	dialogue.anim_name_box.play("hide_name")

# EXPLICACION: En godot no puedes llamar directamente a una func de un autoload
# con el call method track, porque busca func de solo la escena actual
# por eso hace falta crear un "puente"
func start_dialogue_brigde(csv_path):
	dialogue.anim_controller.play("fade_in")
	CD.start_dialogue(csv_path)
