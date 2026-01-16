class_name EnvGen
extends Node2D

# Configurable variables
var camera: Camera2D
@export var chunk_scenes: Array[PackedScene]
@export var screen_size := Vector2(1152, 648)  # size of one chunk/screen
@export var spawn_radius := 2                  # how many screens around the camera to spawn
@export var remove_radius := 3                 # how many screens away to remove chunks

# Internal tracking
var active_chunks := {}         # Dictionary of currently active chunks
var visited_chunks := {}        # Dictionary of visited chunks
var last_camera_grid = null     # Tracks last grid the camera was in

# Ready
func _ready():
	camera = CD.player_camera
	if camera != null:
		last_camera_grid = get_camera_grid()
		spawn_chunks_around_camera()  # spawn initial chunks

# Helper: get camera grid
func get_camera_grid() -> Vector2:
	return Vector2(
		int(camera.global_position.x / screen_size.x),
		int(camera.global_position.y / screen_size.y)
	)

func _process(_delta):
	if camera == null:
		return

	var camera_grid = get_camera_grid()

	if camera_grid != last_camera_grid:
		last_camera_grid = camera_grid

		# Grab the active chunk
		var chunk_instance = active_chunks.get(camera_grid, null)
		var chunk_scene = null
		if chunk_instance != null and chunk_instance.has_meta("origin_scene"):
			chunk_scene = chunk_instance.get_meta("origin_scene")

		mark_chunk_visited(camera_grid, chunk_scene, chunk_instance)

		spawn_chunks_around_camera()
		remove_distant_chunks(camera_grid)


# Spawn chunks around camera
func spawn_chunks_around_camera():
	for x_offset in range(-spawn_radius, spawn_radius + 1):
		for y_offset in range(-spawn_radius, spawn_radius + 1):
			var grid_pos = last_camera_grid + Vector2(x_offset, y_offset)
			if not active_chunks.has(grid_pos):
				spawn_chunk(grid_pos)

# Remove distant chunks
func remove_distant_chunks(camera_grid: Vector2):
	var keys_to_remove := []
	for grid_pos in active_chunks.keys():
		if grid_pos.distance_to(camera_grid) > remove_radius:
			keys_to_remove.append(grid_pos)
	for grid_pos in keys_to_remove:
		active_chunks[grid_pos].queue_free()
		active_chunks.erase(grid_pos)

# Spawn a single chunk
func spawn_chunk(grid_pos: Vector2):
	var chunk_scene = chunk_scenes[randi() % chunk_scenes.size()]
	var chunk_instance = chunk_scene.instantiate()
	chunk_instance.position = grid_pos * screen_size
	# ALWAYS store the original scene
	chunk_instance.set_meta("origin_scene", chunk_scene)
	add_child(chunk_instance)
	active_chunks[grid_pos] = chunk_instance


# Mark chunk as visited
func mark_chunk_visited(grid_pos: Vector2, chunk_scene: PackedScene, chunk_instance: Node):
	if not visited_chunks.has(grid_pos):
		visited_chunks[grid_pos] = {
			"scene": chunk_scene,
			"instance": chunk_instance,
			"events_triggered": []
		}
		print("Player entered chunk at ", grid_pos, " using scene ", chunk_scene)
