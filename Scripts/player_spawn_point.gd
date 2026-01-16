class_name PlayerSpawnPoint extends Node2D


const PLAYER = preload("uid://csvilirrsotay")

var player: Player
var player_camera: Camera2D


func _ready() -> void:
	spawn_player()
	spawn_player_camera()


func spawn_player()->void:
	player = PLAYER.instantiate()
	player.current_step_terrain = player.StepTerrain.GRASS
	add_child(player)
	
func spawn_player_camera()->void:
	player_camera = Camera2D.new()
	player.player_position.add_child(player_camera)
	CD.player_camera = player_camera
