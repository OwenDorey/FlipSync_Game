extends Area2D

@export_enum("Gravity", "Direction", "Freeze") var pickup_type : String

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	
	match pickup_type:
		"Gravity":
			if body.has_method("flip_gravity"):
				body.flip_gravity()
		"Direction":
			if body.has_method("flip_direction"):
				body.flip_direction()
		"Freeze":
			if body.has_method("freeze"):
				body.freeze()
