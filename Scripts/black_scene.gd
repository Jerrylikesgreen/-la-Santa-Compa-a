extends AnimationPlayer

enum enum_scene {MOTHER,LOOP,OLDMAN}
@export var scene_type : enum_scene
# TODO: A FUTURO CAMBIAR ESTO POR ENUM DE ESCENAS
@export var next_scene = "res://Scenes/black_scene.tscn"

@onready var dialogue = $DialogGui
@onready var player = $Player

func _ready():
	dialogue.anim_controller.play("hide_dialogue")
	dialogue.anim_name_box.play("hide_name")

# EXPLICACION: En godot no puedes llamar directamente a una func de un autoload
# con el call method track, porque busca func de solo la escena actual
# por eso hace falta crear un "puente"
func start_dialogue_brigde(csv_path):
	#var a = dialogue.path_csv
	#dialogue.path_csv = csv_path
	#var b = dialogue.path_csv
	#var c = csv_path
	#var aaa = dialogue.arr_dialogue
	dialogue.arr_dialogue = CD.load_csv(csv_path)
	dialogue.index_text = -1
	#var bbb = dialogue.arr_dialogue
	dialogue.anim_controller.play("fade_in")
	#CD.start_dialogue(csv_path)

func change_scene():
	get_tree().change_scene_to_file(next_scene)
