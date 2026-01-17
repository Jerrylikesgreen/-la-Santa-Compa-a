class_name Player extends Node2D

@export var player_interactable = true

@onready var player_body: PlayerBody = %PlayerBody
@onready var player_position: Marker2D = $PlayerBody/PlayerPosition



enum StepTerrain {DEFAULT, DIRT, GRASS}
var current_step_terrain: StepTerrain = StepTerrain.DEFAULT
var tre = 0

func static_play_animation():
	player_body.anim.play("MovingFrontLeft")
