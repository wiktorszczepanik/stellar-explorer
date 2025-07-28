extends CharacterBody2D


const SPEED = 75 # 65.0
const FLY_VELOCITY_FACTOR = -4
const MAX_FLY_RANGE_COUNTER = 110

var last_general_x_direction : bool = true
var last_on_floor_x_direction : bool = true

var fly_action_presed : int = -1
var fly_range_counter : int = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): 
		velocity += get_gravity() * delta
	
	# Handle init x direction (-1.0, 0.0, 1.0)
	var current_x_direction := Input.get_axis("move_left", "move_right")
	
	# Handle jump / fly
	if Input.is_action_just_pressed("fly") and is_on_floor():
		fly_action_presed = 1
		fly_range_counter += 2
		
	if Input.is_action_just_released("fly") and is_on_floor():
		velocity.y = fly_range_counter * FLY_VELOCITY_FACTOR
		fly_action_presed = 0
		fly_range_counter = 0

	# Cannot change direction of jump above the ground
	current_x_direction = set_basic_player_animation(current_x_direction)
	
	if current_x_direction: velocity.x = current_x_direction * SPEED	
	else: velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
# Idle, run, jump
func set_basic_player_animation(current_x_direction) -> float:
	if is_on_floor():
		if current_x_direction > 0:
			animated_sprite.play("run_right")
			last_general_x_direction = true
		elif current_x_direction < 0:
			animated_sprite.play("run_left")
			last_general_x_direction = false
		else: 
			if fly_action_presed == 1:
				if fly_range_counter < MAX_FLY_RANGE_COUNTER:
					if last_general_x_direction == true:
						animated_sprite.play("set_fly_right")
					else:
						animated_sprite.play("set_fly_left")
					fly_range_counter += 2
				else:
					if last_general_x_direction == true:
						animated_sprite.play("set_fly_final_right")
					else:
						animated_sprite.play("set_fly_final_left")
			elif fly_action_presed == 0:
				fly_action_presed = -1
			else:
				if last_general_x_direction == true:
					animated_sprite.play("idle_right")
				else: animated_sprite.play("idle_left")
	else:
		if last_general_x_direction == true:
			animated_sprite.play("jump_right")
		else: animated_sprite.play("jump_left")
		current_x_direction = 1.0 if last_general_x_direction else -1.0
		
	return current_x_direction
