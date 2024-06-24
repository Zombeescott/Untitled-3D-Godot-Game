extends EnemyBase


const SPEED = .1
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	# TODO change it so the gravity doesn't affect it while death animation is occuring
	# also edit the animation to include the collision when it is in the air
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	#velocity.y = JUMP_VELOCITY
	
	if animate and path:
		if animate.current_animation != "Die":
			path.get_parent().progress += delta + SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_complete(anim_name)


func _on_hitbox_component_body_entered(body: Node3D) -> void:
	
	print("here")
	pass
	#if body.get_groups().has("player"):
	#	body.interaction_occured(self).
