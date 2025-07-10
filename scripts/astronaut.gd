extends CharacterBody2D


const SPEED = 75.0
const JUMP_VELOCITY = -320.0

var last_x_direction = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func set_floor_animation(direction) -> void:
	if direction == true:
		animated_sprite.play("idle_right")
	else:
		animated_sprite.play("idle_left")
		
func set_above_ground_animation(direction) -> void:
	if direction == true:
		animated_sprite.play("jump_right")
	else:
		animated_sprite.play("jump_left")
		
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle floor animation (-1, 0, 1)
	var current_x_direction := Input.get_axis("move_left", "move_right")
		
	# Basic animation setup
	if is_on_floor():
		if current_x_direction > 0:
			animated_sprite.play("run_right")
			last_x_direction = true
		elif current_x_direction < 0:
			animated_sprite.play("run_left")
			last_x_direction = false
		else:
			set_floor_animation(last_x_direction)
	else:
		set_above_ground_animation(last_x_direction)

	if current_x_direction:
		velocity.x = current_x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
