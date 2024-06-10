extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 4.5

@onready var y_pivot = $Camera/y_axis
@onready var x_pivot = $Camera/y_axis/x_axis
@onready var t_wall_sens = $"Camera/y_axis/Top Wall Sensor"
@onready var b_wall_sens = $"Camera/y_axis/Bottom Wall Sensor"
@onready var model = $PlayerModel

@export var sens = 0.01
@export var rotate_speed = 12.0
@export var ground_accel = 10.0
@export var air_accel = 9.5

@export var initial_jump_velo: float = 1
@export var jump_velo_rate: float = 1.15
var curr_jump_velo: float

#var const_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var const_gravity = 12
var gravity: float
var aiming: bool = false
var sprinting: bool = false
var crouching: bool = false
var groundPound: bool = false
# Spin attack
var spun: bool = false
var spinning: bool = false
# Jumping
var jumpPad: bool = false
var jumping: bool = false
var doubleJump: bool = false
# Wall hanging
var wallHang: bool = false
var wallPoint: Vector3


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gravity = const_gravity


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
	if !is_on_floor() and !wallHang and !spinning:
		velocity.y -= gravity * delta
	elif spinning:
		velocity.y -= (gravity * delta) / 2
	else:
		# On the ground
		if groundPound:
			$PlayerModel/PlayerAnimation.play("recover")
		if spun:
			spun = false
		if doubleJump:
			doubleJump = false
	
	# Handle actions.
	
	# Thumbstick movement
	if InputEventJoypadMotion:
		if Input.is_action_pressed("camera_left"):
			y_pivot.rotation.y += Input.get_action_strength("camera_left") * sens * 3
		if Input.is_action_pressed("camera_right"):
			y_pivot.rotation.y -= Input.get_action_strength("camera_right") * sens * 3
		if Input.is_action_pressed("camera_up"):
			x_pivot.rotation.x += Input.get_action_strength("camera_up") * sens * 3
		if Input.is_action_pressed("camera_down"):
			x_pivot.rotation.x -= Input.get_action_strength("camera_down") * sens * 3
		y_pivot.rotation.y = wrapf(y_pivot.rotation.y, deg_to_rad(0), deg_to_rad(360))
		x_pivot.rotation.x = clamp(x_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(45))
	if Input.is_action_pressed("jump"):
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				jumping = true
				velocity.y = initial_jump_velo
				curr_jump_velo = initial_jump_velo
			elif !wallHang and !t_wall_sens.is_colliding() and b_wall_sens.is_colliding():
				# Check if player can hang off a wall
				wallHang = true
				velocity.y = 0
				wallPoint = b_wall_sens.get_collision_point()
			elif !doubleJump and !groundPound:
				# Double jumping
				if wallHang:
					wallHang = false
					wallPoint = Vector3.ZERO
				# Less velocity for double jump
				velocity.y = initial_jump_velo / 1.25
				curr_jump_velo = initial_jump_velo / 1.25
				doubleJump = true
		else:
			# Holding down jump
			if velocity.y >= 0 and !wallHang and !groundPound:
				# Slow jump down longer jump button is held
				curr_jump_velo /= jump_velo_rate
				velocity.y += curr_jump_velo
	# Aim
	if Input.is_action_just_pressed("aim"):
		aiming = true
	if Input.is_action_just_released("aim"):
		aiming = false
	# Sprint
	if Input.is_action_just_pressed("sprint"):
		#TODO don't allow sprinting mid-air when other features are complete
		sprinting = true
	if Input.is_action_just_released("sprint"):
		sprinting = false
	# Crouch
	if Input.is_action_just_pressed("crouch"):
		if !is_on_floor() and !groundPound and !wallHang:
			if spinning:
				$PlayerModel/PlayerAnimation.stop()
				spinning = false
			groundPound = true
			velocity = Vector3.ZERO
			gravity = 0
			$PlayerModel/PlayerAnimation.play("start_ground_pound")
		else:
			crouching = true
	if Input.is_action_just_released("crouch"):
		crouching = false
	if Input.is_action_just_pressed("attack"):
		if !spun and !spinning and !groundPound:
			if !is_on_floor():
				spun = true
			spinning = true
			$PlayerModel/PlayerAnimation.play("spin_attack")
			velocity.y = 0
	
	# Handle the movement/deceleration.
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
	if is_on_floor() or spinning:
		velocity = lerp(velocity, direction * SPEED * speed_multiplier, ground_accel * delta)
	else:
		velocity = lerp(velocity, direction * SPEED * speed_multiplier, air_accel * delta)
	velocity.y = vy
	
	# Direction provided
	if direction and !groundPound:
		$PlayerModel/AnimationPlayer.speed_scale = speed_multiplier
		$PlayerModel/AnimationPlayer.play("Walking")
		
		if wallHang:
			if position.distance_to(wallPoint) >= 1:
				velocity = Vector3()
			if position.y >= wallPoint.y + .1 or position.y <= wallPoint.y - .1:
				# If moving up/down stop wall hang
				wallHang = false
				wallPoint = Vector3.ZERO
		
	# No direction input
	elif !groundPound:
		if wallHang and wallPoint != Vector3.ZERO:
			# Makes return to wallpoint smoother after moving
			direction = (wallPoint - position).normalized()
			position.x += direction.x * SPEED * delta
			position.z += direction.z * SPEED * delta
		else:
			$PlayerModel/AnimationPlayer.play("Rest")

	move_and_slide()
	
	# Change direction model is facing while moving
	if aiming:
		# Move model in direction of camera
		model.rotation.y = lerp_angle(model.rotation.y, y_pivot.rotation.y, rotate_speed * delta)
	elif Vector3(velocity.x, 0, velocity.z).length() >= 1:
		# Move model in direction of keys
		var look_dir = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_dir.angle() + deg_to_rad(180), rotate_speed * delta)


func item_collected() -> void:
	$"User Interface".update_ui()

func interaction_occured(action: String) -> void:
	match action:
		"jumppad":
			velocity.y = JUMP_VELOCITY * 2
			# Refresh without touching ground
			doubleJump = false
			groundPound = false
			spun = false
			gravity = const_gravity


func _on_player_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"start_ground_pound":
			gravity = 25
			velocity.y -= 5
		"recover":
			groundPound = false
			gravity = const_gravity
		"spin_attack":
			spinning = false
