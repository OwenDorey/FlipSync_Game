extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export_enum("Red", "Blue") var colour : String
@export var group_name : String

var on_colour : Color
@export var off_colour : Color

var in_door : bool = false
var root

func _ready() -> void:
	on_colour = sprite_2d.modulate
	root = get_tree().current_scene
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(group_name):
		sprite_2d.modulate = off_colour
		in_door = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(group_name):
		sprite_2d.modulate = on_colour
		in_door = false
		
func _process(delta: float) -> void:
	match in_door:
		true:
			match colour:
				"Red":
					root.red_door_time += delta
				"Blue":
					root.blue_door_time += delta
					
		false:
			match colour:
				"Red":
					root.red_door_time = 0
				"Blue":
					root.blue_door_time = 0
