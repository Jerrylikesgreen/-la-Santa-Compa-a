class_name EnviormentSpawner extends Node2D

# Refrences to Enirments scenes that will be spawned. 
@export var large_tree_scene: PackedScene
@export var small_tree_scene: PackedScene
@export var bush_scene: PackedScene

## Determins the size of the Map Generation. 
@export var map_width := 120
@export var map_height := 120

## Determins the spacing between each cell being generated (Can be an enviorment or empty space)
@export var cell_size := 64

# Seed to keep consistancy. 
@export var seed := 12345


# Initiating the differant perline noises for each spawnable object and empty space (Clearing)
var clearing_noise := FastNoiseLite.new()
var terrain_noise := FastNoiseLite.new()
var large_tree_noise := FastNoiseLite.new()
var small_tree_noise := FastNoiseLite.new()
var bush_noise := FastNoiseLite.new()

# Threshholds that determin frequency of spawn High value lower frequency. 
const CLEARING_THRESHOLD := 0.5
const BUSH_THRESHOLD := 0.6
const SMALL_TREE_THRESHOLD := 0.6
const LARGE_TREE_THRESHOLD := 0.7



func _ready() -> void:
	randomize()
	_setup_noise()
	generate_terrain()


func _setup_noise() -> void:
	# CLEARINGS (large-scale)
	clearing_noise.seed = seed
	clearing_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	clearing_noise.frequency = 0.01 # large open areas
	
	# LARGE TREES (scattered)
	large_tree_noise.seed = seed + 1
	large_tree_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	large_tree_noise.frequency = 0.02

	# SMALL TREES (clustered)
	small_tree_noise.seed = seed + 2
	small_tree_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	small_tree_noise.frequency = 0.02

	# BUSHES (patchy)
	bush_noise.seed = seed + 3
	bush_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	bush_noise.frequency = 0.03

func sample(noise: FastNoiseLite, x: float, y: float) -> float:
	return (noise.get_noise_2d(x, y) + 1.0) * 0.5


func get_noise(x: float, y: float) -> float:
	var v = terrain_noise.get_noise_2d(x, y)
	return (v + 1.0) * 0.5
	
func generate_terrain() -> void:
	for x in map_width:
		for y in map_height:
			var world_x = x * cell_size
			var world_y = y * cell_size

			# Skip clearings
			if is_clearing(world_x, world_y):
				continue

			var large_v = sample(large_tree_noise, world_x, world_y)
			var small_v = sample(small_tree_noise, world_x, world_y)
			var bush_v  = sample(bush_noise, world_x, world_y)

			# Large trees are rare & isolated
			if large_v > LARGE_TREE_THRESHOLD  and randf() < 0.4:
				spawn_large_tree(world_x, world_y)
				continue

			# Small trees cluster
			if small_v > SMALL_TREE_THRESHOLD:
				spawn_small_tree(world_x, world_y)
				continue

			# Bushes fill gaps
			if bush_v > BUSH_THRESHOLD:
				spawn_bush(world_x, world_y)




func spawn_large_tree(x: float, y: float) -> void:
	if randf() > 0.6:
		return

	_spawn(large_tree_scene, x, y, 0.9, 1.1)


func spawn_small_tree(x: float, y: float) -> void:
	if randf() > 0.7:
		return

	_spawn(small_tree_scene, x, y, 0.85, 1.05)


func spawn_bush(x: float, y: float) -> void:
	if randf() > 0.8:
		return

	_spawn(bush_scene, x, y, 0.8, 1.0)


func _spawn(scene: PackedScene, x: float, y: float, min_scale: float, max_scale: float) -> void:
	if scene == null:
		return

	var inst = scene.instantiate()
	inst.position = Vector2(x, y) + Vector2(
		randf_range(-cell_size * 0.25, cell_size * 0.25),
		randf_range(-cell_size * 0.25, cell_size * 0.25)
	)

	inst.scale *= randf_range(min_scale, max_scale)
	add_child(inst)

func is_clearing(x: float, y: float) -> bool:
	var v = clearing_noise.get_noise_2d(x, y)
	v = (v + 1.0) * 0.5
	return v < CLEARING_THRESHOLD
