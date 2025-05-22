extends CanvasLayer

@export var level_number : int
@onready var label: Label = $VBoxContainer/Label
@onready var button_sound: AudioStreamPlayer2D = $ButtonSound

func _ready() -> void:
	label.text = "Level " + str(level_number)

func _on_retry_button_button_down() -> void:
	button_sound.play()
	get_tree().current_scene.reload_level()

func _on_menu_button_button_down() -> void:
	button_sound.play()
	get_tree().current_scene.load_menu()
