extends Control

@onready var scene_transition_animation: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var level_buttons: GridContainer = $Levels/LevelButtons

func _ready() -> void:
	for i in range(1, 9):
		var button = level_buttons.get_node("Button%d" % i)
		button.pressed.connect(_on_level_button_pressed.bind(i))
		
func _on_level_button_pressed(level_index):
	var path = "res://Scenes/Levels/level_%d.tscn" % level_index
	load_scene(path)

func load_scene(scene_name : String):
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().change_scene_to_file(scene_name)
	
func _on_play_button_button_down() -> void:
	load_scene("res://Scenes/Levels/level_1.tscn")

func _on_quit_button_button_down() -> void:
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().quit()

func _on_level_select_button_button_down() -> void:
	animation_player.play("open_level_select")

func _on_back_button_button_down() -> void:
	animation_player.play("open_menu")
