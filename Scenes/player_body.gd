class_name PlayerBody extends CharacterBody2D

@export var speed: float = 200.0


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed

		if animation_player.current_animation != "Moving":
			animation_player.play("Moving")
	else:
		velocity = Vector2.ZERO
		
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")

	move_and_slide()
