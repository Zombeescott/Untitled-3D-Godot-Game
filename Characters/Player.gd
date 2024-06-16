extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 4.5

@onready var model = $"Physics collision/PlayerModel"
@onready var y_pivot = $Camera/y_axis
@onready var x_pivot = $Camera/y_axis/x_axis
@onready var t_wall_sens = $"Camera/y_axis/Top Wall Sensor"
@onready var b_wall_sens = $"Camera/y_axis/Bottom Wall Sensor"
@onready var shadowRay = $ShadowCast

@export var sens = 0.01
@export var rotate_speed = 12.0
@export var ground_accel = 10.0
@export var air_accel = 1.5
# Jumping
@export var initial_jump_velo: float = 1
@export var jump_velo_rate: float = 1.15
var curr_jump_velo: float
# Input Buffer
@export var input_buffer: int = 20
var buffer_counter: int
var buffer_action: String
var buffer_used: bool = false 

#var const_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var const_gravity = 12
var gravity: float
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
# Dashing
var dashed: bool = false
var down_dash: bool = false
var initial_dash: bool = false
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


# Ran when an action can be performed again and auto activiates a saved action
func buffer_check(action_ended : String) -> void:
	if buffer_counter > 0:
		#print("Buffer ", buffer_action)
		if buffer_action == "jump" and action_ended != "spinning":
			buffer_used = true
			jump()
		if buffer_action == "dash":
			dash()
		if buffer_action == "spin":
			spin()
		
		# Reset buffer
		buffer_counter = 0
		buffer_action = ""


func buffer_set(action : String) -> void:
	#print("Set buffer")
	buffer_counter = input_buffer
	buffer_action = action


# Returns false if buffer_used was true and sets it back to false
# Only used for jump function but maybe useful somewhere else idk idc
func buffer_used_reset() -> bool:
	if buffer_used:
		buffer_used = false
		return false
	return true


func _physics_process(delta: float) -> void:
	# Gravity and floor detection
	if !is_on_floor() and !wallHang and !spinning:
		velocity.y -= gravity * delta
	elif spinning:
		velocity.y -= (gravity * delta) / 2
	else:
		# On the ground
		if groundPound:
			$"Physics collision/PlayerModel/PlayerAnimation".play("recover")
		if spun:
			spun = false
		if doubleJump:
			doubleJump = false
		if dashed or down_dash:
			dashed = false
			down_dash = false
			initial_dash = false
		# Check for any saved actions
		buffer_check("air")
	if buffer_counter > 0:
		#print(buffer_counter)
		buffer_counter -= 1
	# Cast shadow under player
	if shadowRay.is_colliding():
		if $ShadowCast/Shadow.visible == false:
			$ShadowCast/Shadow.visible = true
		$ShadowCast/Shadow.global_position.y = float("%.4f" % shadowRay.get_collision_point().y)
		if velocity.y < 0:
			# make sure shadow shows up when player is going downwards
			$ShadowCast/Shadow.global_position.y += (abs(velocity.y) * .02) + .01
		else:
			$ShadowCast/Shadow.global_position.y += .015
	else:
		$ShadowCast/Shadow.visible = false
	
	# Basic movement
	if InputEventJoypadMotion:
		var joySens = 5
		if Input.is_action_pressed("camera_left"):
			y_pivot.rotation.y += Input.get_action_strength("camera_left") * sens * joySens
		if Input.is_action_pressed("camera_right"):
			y_pivot.rotation.y -= Input.get_action_strength("camera_right") * sens * joySens
		if Input.is_action_pressed("camera_up"):
			x_pivot.rotation.x += Input.get_action_strength("camera_up") * sens * joySens
		if Input.is_action_pressed("camera_down"):
			x_pivot.rotation.x -= Input.get_action_strength("camera_down") * sens * joySens
		y_pivot.rotation.y = wrapf(y_pivot.rotation.y, deg_to_rad(0), deg_to_rad(360))
		x_pivot.rotation.x = clamp(x_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(45))
	if Input.is_action_just_pressed("dash"):
		dash()
	# Sprint
	if Input.is_action_just_pressed("sprint"):
		sprinting = true
	if Input.is_action_just_released("sprint"):
		sprinting = false
	# Crouch / Ground pound
	if Input.is_action_just_pressed("crouch"):
		if !is_on_floor() and !groundPound and !wallHang:
			if spinning:
				$"Physics collision/PlayerModel/PlayerAnimation".stop()
				spinning = false
			groundPound = true
			velocity = Vector3.ZERO
			gravity = 0
			$"Physics collision/PlayerModel/PlayerAnimation".play("start_ground_pound")
		else:
			crouching = true
	if Input.is_action_just_released("crouch"):
		crouching = false
	# Attack
	if Input.is_action_just_pressed("attack"):
		spin()
	if Input.is_action_pressed("jump"):
		if buffer_used_reset():
			jump()
	
	# Modify the movement/deceleration.
	var speed_multiplier = 1.5
	if (dashed or down_dash) and !initial_dash:
		speed_multiplier = 7
		#$"Physics collision/PlayerModel/AnimationPlayer".play("dash_end")
	elif spinning:
		speed_multiplier = 2
	elif crouching:
		speed_multiplier = .5
	elif sprinting:
		speed_multiplier = 1
	
	# Make player move
	var vy = velocity.y
	velocity.y = 0
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, y_pivot.rotation.y).normalized()
	# Make player accelerate
	if (dashed or down_dash) and initial_dash:
		# Restrict movement while dashing
		velocity = lerp(velocity, direction * SPEED * speed_multiplier, air_accel * delta)
	else:
		velocity = lerp(velocity, direction * SPEED * speed_multiplier, ground_accel * delta)
		# Make hard to change direction after giving dash boost
		if (dashed or down_dash) and !initial_dash:
			initial_dash = true
	velocity.y = vy
	
	# Direction provided
	if direction and !groundPound:
		$"Physics collision/PlayerModel/AnimationPlayer".speed_scale = speed_multiplier
		$"Physics collision/PlayerModel/AnimationPlayer".play("Walking")
		
		if wallHang:
			if position.distance_to(wallPoint) >= 1:
				velocity = Vector3.ZERO
			if position.y >= wallPoint.y + 1 or position.y <= wallPoint.y - 1:
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
			$"Physics collision/PlayerModel/AnimationPlayer".play("Rest")

	move_and_slide()
	
	# Move model in direction of keys
	if Vector3(velocity.x, 0, velocity.z).length() >= 1:
		var look_dir = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_dir.angle() + deg_to_rad(180), rotate_speed * delta)


# Abilities -----------


func jump() -> void:
	if Input.is_action_just_pressed("jump") or buffer_used:
		if is_on_floor():
			jumping = true
			if crouching:
				velocity.y = initial_jump_velo * 2.0 * 2
			else:
				velocity.y = initial_jump_velo * 2.0
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
			velocity.y = (initial_jump_velo / 1.25) * 1.5
			curr_jump_velo = initial_jump_velo / 1.25
			doubleJump = true
		else:
			# Input buffer
			buffer_set("jump")
	else:
		# Holding down jump
		if velocity.y >= 0 and !wallHang and !groundPound:
			# Slow jump down longer jump button is held
			curr_jump_velo /= jump_velo_rate
			velocity.y += curr_jump_velo


func dash() -> void:
	if !spinning and !groundPound:
		#$"Physics collision/PlayerModel/AnimationPlayer".play("dash")
		if is_on_floor() and !dashed:
			velocity.y = 4
			dashed = true
		elif !is_on_floor() and !down_dash:
			velocity.y = -2.5
			down_dash = true
	else:
		# Input buffer
		buffer_set("dash")


func spin() -> void:
	if !spun and !spinning and !groundPound:
		if !is_on_floor():
			spun = true
		spinning = true
		$"Physics collision/PlayerModel/PlayerAnimation".play("spin_attack")
		if velocity.y < 0:
			velocity.y = 0
	else:
		# Input buffer
		buffer_set("spin")


func refresh_abilities() -> void: 
	doubleJump = false
	groundPound = false
	spun = false
	dashed = false
	down_dash = false
	gravity = const_gravity
	$"Physics collision/PlayerModel/GP attack component/Butt square".disabled = true


# Signals / Called from other scripts -----------


func item_collected() -> void:
	$"User Interface".update_ui()


func interaction_occured(action) -> void:
	match action.type:
		"jumppad":
			velocity.y = action.strength
			call_deferred("refresh_abilities")


func _on_player_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"start_ground_pound":
			gravity = 25
			velocity.y -= 5
			$"Physics collision/PlayerModel/GP attack component/Butt square".disabled = false
		"recover":
			groundPound = false
			gravity = const_gravity
			$"Physics collision/PlayerModel/GP attack component/Butt square".disabled = true
		"spin_attack":
			spinning = false
			buffer_check("spinning")
		"dash":
			pass
			$"Physics collision".rotate(-90)
		"dash_end":
			pass
			$"Physics collision".rotate(180)
