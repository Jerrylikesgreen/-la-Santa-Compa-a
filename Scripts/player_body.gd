class_name PlayerBody
extends CharacterBody2D

@export var debug: bool = false
@export var speed: float = 100.0
@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var player_sfx: PlayerSfx = %PlayerSfx


var front_facing : bool = true
var facing_left : bool = true
var interactable


func _on_body_entered()->void:
	print("Enterd")

func _ready():
	interactable = get_parent().player_interactable

func _physics_process(_delta: float) -> void:
	if !interactable: return
	
	#if CD.player_movement:
	var direction := Vector2.ZERO
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")

	CD.moving = direction != Vector2.ZERO

	if CD.moving and (CD.player_movement or CD.auto_mode == CD.auto_mode_enum.AUTO_WALK):
		direction = direction.normalized()
		velocity = direction * speed
		update_facing(direction)
	else:
		velocity = Vector2.ZERO

	play_animation(CD.moving)
	move_and_slide()

func update_facing(direction: Vector2) -> void:
	if direction.y != 0:
		front_facing = direction.y > 0
	if direction.x != 0:
		facing_left = direction.x < 0

func play_animation(moving: bool) -> void:
	var anim_name := ""
	anim_name += "Moving" if moving else "Idle"
	anim_name += "Front" if front_facing else "Back"
	anim_name += "Left" if facing_left else "Right"

	if anim.current_animation != anim_name:
		if debug:
			print(anim_name)
		anim.play(anim_name)
		
