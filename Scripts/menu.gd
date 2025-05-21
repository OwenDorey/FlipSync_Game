extends Control

@onready var scene_transition_animation: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer

func load_scene(scene_name : String):
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().change_scene_to_file(scene_name)
	
func _on_play_button_button_down() -> void:
	load_scene("res://Scenes/Levels/level_5.tscn")

func _on_quit_button_button_down() -> void:
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().quit()
