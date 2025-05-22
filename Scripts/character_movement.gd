extends CharacterBody2D

# Movement
const SPEED : float = 120.0
const JUMP_VELOCITY : float = -270.0
@export_enum("Down:1", "Up:-1") var gravity_direction : int = 1
@export_enum("Normal:1", "Inverse:-1") var walk_direction : int = 1
var is_frozen : bool = false

@export var particle_colour : Color
const DEATH_PARTICLES = preload("res://Scenes/Other/death_particles.tscn")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var tile_map_layer : TileMapLayer
var root

func _ready() -> void:
	root = get_tree().current_scene
	tile_map_layer = root.get_node("TileMapLayer")
	if gravity_direction == -1:
		up_direction *= -1
	
func flip_gravity() -> void:
	gravity_direction *= -1
	up_direction *= -1
	
func flip_direction() -> void:
	walk_direction *= -1
	
func freeze() -> void:
	is_frozen = true
	velocity.x = 0
	await get_tree().create_timer(4.0).timeout
	is_frozen = false

func _physics_process(delta: float) -> void:
	# Add gravity
	velocity += get_gravity() * gravity_direction * delta

	# Handle jump
	if Input.is_action_pressed("jump") and is_on_floor() and !is_frozen:
		velocity.y = JUMP_VELOCITY * gravity_direction

	# Input direction
	var direction := Input.get_axis("move_left", "move_right")
	direction *= walk_direction
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Turn character
	if gravity_direction == 1:
		rotation_degrees = 0
	else:
		rotation_degrees = 180
		
	# Play animations
	if is_frozen:
		animated_sprite.play("jump")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if is_frozen == false:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
				
func finish_game():
	# Disable movement
	set_physics_process(false)
	set_physics_process(false)
	
	# New tween
	var tween = get_tree().create_tween()
	
	# Parallel animations
	tween.set_parallel()
	
	# Animate rotation
	tween.tween_property(self, "rotation", rotation + 1.5 * PI, 1.5)  # 2 full spins in 1.5 seconds
	
	# Animate scale
	tween.tween_property(self, "scale", Vector2(0, 0), 1.5)  # Shrinks to 0 size
	
	# Animate fade
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	# Optional: Queue free after animation
	await tween.finished
	queue_free()
	
func die():
	var particle = DEATH_PARTICLES.instantiate()
	particle.self_modulate = particle_colour
	particle.position = global_position
	particle.rotation = global_rotation
	particle.emitting = true
	get_tree().current_scene.add_child(particle)
	root.character_died()
	queue_free()
