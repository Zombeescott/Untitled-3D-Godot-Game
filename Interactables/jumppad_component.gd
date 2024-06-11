extends Area3D
class_name JumppadComponent


@export var type: String
@export var strength: float
@export var pop_timer: Timer

var monitor: bool = true


func _on_body_entered(body: Node3D) -> void:
	# Using monitor because self.monitoring doesn't work for some reason and idc
	if body.get_groups().has("entity") and monitor:
		body.interaction_occured(self)
		
		# Time until reappear
		if pop_timer:
			$MeshInstance3D.visible = false
			#self.monitoring = false
			monitor = false
			pop_timer.start()


func _on_timer_timeout() -> void:
	$MeshInstance3D.visible = true
	#self.monitoring = true
	monitor = true
