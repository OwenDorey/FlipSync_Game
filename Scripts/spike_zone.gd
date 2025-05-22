extends Area2D

@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		death_sound.play()
		body.die()
