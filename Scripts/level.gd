extends Node2D

const ENVIRONMENT_SETTINGS = preload("res://Scenes/Other/environment_settings.tscn")

var levels = [
	load("res://Scenes/Levels/level_1.tscn"),
	load("res://Scenes/Levels/level_2.tscn"),
	load("res://Scenes/Levels/level_3.tscn"),
	load("res://Scenes/Levels/level_4.tscn"),
	load("res://Scenes/Levels/level_5.tscn"),
	load("res://Scenes/Levels/level_6.tscn"),
	load("res://Scenes/Levels/level_7.tscn"),
	load("res://Scenes/Levels/level_8.tscn")
]

var one_door : bool
var has_finished : bool = false
var has_died : bool = false

const MAX_DOOR_TIME : float = 0.5

var red_door_time : float = 0
var blue_door_time : float = 0

@onready var scene_transition_animation: AnimationPlayer = $SceneTransitionAnimation/AnimationPlayer
@onready var win_sound: AudioStreamPlayer2D = $WinSound

func _ready() -> void:
	scene_transition_animation.get_parent().get_node("ColorRect").color.a = 255
	scene_transition_animation.play("fade_out")
	var environment_instance = ENVIRONMENT_SETTINGS.instantiate()
	add_child(environment_instance)
	
	if has_node("RedDoor") and has_node("BlueDoor"):
		one_door = false
	else:
		one_door = true
		
# Get current level number
func get_level_index() -> int:
	var current_scene = get_tree().current_scene.scene_file_path
	for i in range(levels.size()):
		if levels[i].resource_path == current_scene:
			return i
	return -1
		
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_level"):
		load_next_level()
		
	if Input.is_action_just_pressed("restart_level"):
		reload_level()
		
	if Input.is_action_just_pressed("open_menu"):
		load_menu()
		
	if one_door == true:
		if red_door_time > MAX_DOOR_TIME or blue_door_time > MAX_DOOR_TIME:
			finish_level()
	elif one_door == false:
		if red_door_time > MAX_DOOR_TIME and blue_door_time > MAX_DOOR_TIME:
			finish_level()
			
# Restart level
func reload_level():
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().reload_current_scene()

# Find and start next level
func load_next_level():
	var current_level = get_level_index()
	if current_level != -1 and current_level + 1 < levels.size():
		get_tree().change_scene_to_packed(levels[current_level + 1])
	else:
		get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")
		
# Open menu
func load_menu():
	scene_transition_animation.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	set_physics_process(false)
	get_tree().change_scene_to_file("res://Scenes/UI/menu.tscn")

# On player death
func character_died():	
	if has_died == false:
		has_died = true
		await get_tree().create_timer(0.7).timeout
		reload_level()
		
# On level complete
func finish_level():
	if has_finished == false:
		win_sound.play()
		has_finished = true
		if has_node("RedChar"):
			get_node("RedChar").finish_game()
		if has_node("BlueChar"):
			get_node("BlueChar").finish_game()
			
		await get_tree().create_timer(1.0).timeout
		load_next_level()
