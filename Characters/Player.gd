extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 4.5
const accel = 6.0
var GRAVITY = ProjectSettings.get_setting("physics/3d/default_gravity")

#@onready var pivot = $CamOrigin
@onready var y_pivot = $CamOrigin/y_axis
@onready var x_pivot = $CamOrigin/y_axis/x_axis
@onready var t_wall_sens = $"CamOrigin/y_axis/Top Wall Sensor"
@onready var b_wall_sens = $"CamOrigin/y_axis/Bottom Wall Sensor"
@onready var model = $star

@export var sens = 0.01
@export var rotate_speed = 12.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var aiming: bool = false
var sprinting: bool = false
var crouching: bool = false
var groundPound: bool = false

var jumpPad: bool = false
var doubleJump: bool = false

var wallHang: bool = false
var wallPoint: Vector3


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		# Mouse movement
		x_pivot.rotation.x -= event.relative.y * sens
		x_pivot.rotation.x = clamp(x_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(45))
		y_pivot.rotation.y -= event.relative.x * sens
		y_pivot.rotation.y = wrapf(y_pivot.rotation.y, deg_to_rad(0), deg_to_rad(360))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !wallHang:
		velocity.y -= gravity * delta
	else:
		if groundPound:
			$star/PlayerAnimation.play("recover")
		doubleJump = false
	
	# Handle actions.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Check if player can hang off a wall
		elif !wallHang and !t_wall_sens.is_colliding() and b_wall_sens.is_colliding():
			wallHang = true
			velocity.y = 0
			wallPoint = b_wall_sens.get_collision_point()
		elif !doubleJump:
			if wallHang:
				wallHang = false
				wallPoint = Vector3.ZERO
			velocity.y = JUMP_VELOCITY
			doubleJump = true
	# Aim
	if Input.is_action_just_pressed("aim"):
		aiming = true
	if Input.is_action_just_released("aim"):
		aiming = false
	# Sprint
	if Input.is_action_just_pressed("sprint"):
		sprinting = true
	if Input.is_action_just_released("sprint"):
		sprinting = false
	# Crouch
	if Input.is_action_just_pressed("crouch"):
		if !is_on_floor():
			groundPound = true
			velocity = Vector3.ZERO
			gravity = 0
			$star/PlayerAnimation.play("start_ground_pound")
		else:
			crouching = true
	if Input.is_action_just_released("crouch"):
		crouching = false
	
	# Get the input direction and handle the movement/deceleration.
	var speed_multiplier = 1
	if crouching:
		speed_multiplier = .5
	elif sprinting:
		speed_multiplier = 1.5
	# Make player move
	var vy = velocity.y
	velocity.y = 0
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, y_pivot.rotation.y).normalized()
	# Make player accelerate
	velocity = lerp(velocity, direction * SPEED * speed_multiplier, accel * delta)
	velocity.y = vy
	
	# Direction provided
	if direction and !groundPound:
		$star/AnimationPlayer.speed_scale = speed_multiplier
		$star/AnimationPlayer.play("Walking")
		
		if wallHang:
			if position.distance_to(wallPoint) >= 1:
				velocity = Vector3()
			if position.y >= wallPoint.y + .1 or position.y <= wallPoint.y - .1:
				# If moving up/down stop wall hang
				wallHang = false
				wallPoint = Vector3.ZERO
		
	# No direction input
	elif !groundPound:
		# Trying to add friction (Add is_on_floor for momentum midair)
		#if velocity.length() >= (friction * delta):
		#	velocity -= velocity.normalized() * (friction * delta)
		if wallHang and wallPoint != Vector3.ZERO:
			# Makes return to point move smoother
			direction = (wallPoint - position).normalized()
			position.x += direction.x * SPEED * delta
			position.z += direction.z * SPEED * delta
		elif !is_on_floor():
			#TODO for some reason, acceleration only works if it is ! or "" not both
			# 1.5 since model will misbehave after sprinting (.01 to test deceleration)
			velocity.x = move_toward(velocity.x, 0, SPEED * 1.5)
			velocity.z = move_toward(velocity.z, 0, SPEED * 1.5)
			$star/AnimationPlayer.play("Rest")

	move_and_slide()
	
	# if statements to change direction model is facing while moving
	if aiming:
			# Move model in direction of camera
			model.rotation.y = lerp_angle(model.rotation.y, y_pivot.rotation.y, rotate_speed * delta)
	elif Vector3(velocity.x, 0, velocity.z).length() >= 1:
		# Move model in direction of keys
		var look_dir = Vector2(velocity.z, velocity.x)
		model.rotation.y = look_dir.angle() + deg_to_rad(180)


func item_collected() -> void:
	$"User Interface".update_ui()
	

func interaction_occured(action: String) -> void:
	match action:
		"jumppad":
			velocity.y = JUMP_VELOCITY * 2
			# Refresh without touching ground
			doubleJump = false
			groundPound = false
			gravity = GRAVITY


func _on_player_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"start_ground_pound":
			gravity = 25
			velocity.y -= 5
		"recover":
			groundPound = false
			gravity = GRAVITY
