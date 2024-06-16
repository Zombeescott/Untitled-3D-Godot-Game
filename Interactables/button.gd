extends Node3D


@export var animate: AnimationPlayer
@export var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.get_groups().has("entity"):
		#print(body.velocity.y)
		if timer.time_left > 0:
			animate.play("activate_stepped_on_activate")
		elif body.velocity.y < -10:
			# doesn't work correctly but idc
			animate.play("activate_fast")
		else:
			animate.play("activate")
		if timer:
			timer.start()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if timer:
		if timer.time_left > 0:
			animate.play("step_off_while_activate")
		else:
			animate.play("deactivate")
	else:
		animate.play("deactivate")


func _on_timer_timeout() -> void:
	animate.play("stepped_off_deactivate")
