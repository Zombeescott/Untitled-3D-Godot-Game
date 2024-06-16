extends Node3D


@export var animate: AnimationPlayer
@export var timer: Timer
@export var coins: Array[ItemBase]

@export var num_coins: int = 3
var coins_collected: int = 0


func _ready() -> void:
	if coins:
		for i in coins:
			# Give all coins a reference to the button
			i.button = self


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
			if coins:
				coins_collected = 0
				# Make coins appear
				for i in coins:
					i.appear()


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
	if coins:
		# Make coins disappear
		for i in coins:
			i.hide_item()
