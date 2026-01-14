class_name Player extends Node2D
@onready var player_body: PlayerBody = %PlayerBody
@onready var player_position: Marker2D = $PlayerBody/PlayerPosition



enum StepTerrain {DEFAULT, DIRT, GRASS}
var current_step_terrain: StepTerrain = StepTerrain.DEFAULT
var tre = 0
