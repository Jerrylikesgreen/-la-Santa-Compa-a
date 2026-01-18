class_name OpeningScene extends Node2D

@onready var opening_scene_animation_player: AnimationPlayer = %OpeningSceneAnimationPlayer

var current_animation_indx:int = 0



func _animation_finished()->void:
	current_animation_indx += 1
	var next_anim := "animation" + str(current_animation_indx)
	
	if opening_scene_animation_player.has_animation(next_anim):
		opening_scene_animation_player.play(next_anim)
	
	print(current_animation_indx)
	print(opening_scene_animation_player.current_animation)
