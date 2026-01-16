class_name PlayerSfx
extends AudioStreamPlayer

const DEFAULT_STEP = preload("uid://crbq2okhas7vl")
const DIRT_STEP = preload("uid://q5rhq4n3081j")
const GRASS_STEP = preload("uid://belnyx2roxpmc")


var current_terrain: Player.StepTerrain

func _ready() -> void:
	var parent: Player = get_parent()
	current_terrain = parent.current_step_terrain

func play_step() -> void:
	match current_terrain:
		Player.StepTerrain.GRASS:
			stream = GRASS_STEP
			play()
		Player.StepTerrain.DIRT:
			stream = DIRT_STEP
			play()
		_:
			stream = DEFAULT_STEP
			play()
