class_name EnvGen
extends Node2D
var camera: Camera2D
@export var chunk_scenes: Array[PackedScene]
@export var screen_size := Vector2(1152, 648) # size of one chunk/screen
@export var spawn_radius := 2 # how many screens away to spawn chunks
@export var remove_radius := 2 # how many screens away to remove chunks

var active_chunks := {}
var last_camera_grid := Vector2.INF # impossible initial value

func _ready():
	camera = CD.player_camera  # autoload reference to the player's camera
	spawn_chunks_around_camera()  # initial spawn

func _process(_delta):
	if camera == null:
		return

	var camera_grid = Vector2(
		int(camera.global_position.x / screen_size.x),
		int(camera.global_position.y / screen_size.y)
	)

	# Only update if the camera moved into a new grid
	if camera_grid != last_camera_grid:
		last_camera_grid = camera_grid
		spawn_chunks_around_camera()
		remove_distant_chunks(camera_grid)

func spawn_chunks_around_camera():
	# Spawn chunks within spawn_radius around the camera
	for x_offset in range(-spawn_radius, spawn_radius + 1):
		for y_offset in range(-spawn_radius, spawn_radius + 1):
			var grid_pos = last_camera_grid + Vector2(x_offset, y_offset)
			if not active_chunks.has(grid_pos):
				spawn_chunk(grid_pos)

func remove_distant_chunks(camera_grid: Vector2):
	var keys_to_remove := []
	for grid_pos in active_chunks.keys():
		# Remove chunks that are farther than remove_radius from the camera
		if grid_pos.distance_to(camera_grid) > remove_radius:
			keys_to_remove.append(grid_pos)
	for grid_pos in keys_to_remove:
		active_chunks[grid_pos].queue_free()
		active_chunks.erase(grid_pos)

func spawn_chunk(grid_pos: Vector2):
	var chunk_scene = chunk_scenes[randi() % chunk_scenes.size()]
	var chunk_instance = chunk_scene.instantiate()
	chunk_instance.position = grid_pos * screen_size
	add_child(chunk_instance)
	active_chunks[grid_pos] = chunk_instance
