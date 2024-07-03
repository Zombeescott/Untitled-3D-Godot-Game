extends Area3D
class_name JumppadComponent


@export var type: String
@export var strength: float
@export var pop_timer: Timer
@export var collision: CollisionShape3D


func _on_body_entered(body: Node3D) -> void:
	if body.get_groups().has("entity"):
		body.interaction_occured(self)
		
		# Time until reappear
		if pop_timer:
			self.visible = false
			self.set_deferred("monitoring", false)
			self.set_collision_layer_value(1, false)
			if collision:
				collision.set_deferred("disabled", true)
			pop_timer.start()


func _on_timer_timeout() -> void:
	self.visible = true
	self.set_deferred("monitoring", true)
	self.set_collision_layer_value(1, true)
	if collision:
		collision.set_deferred("disabled", false)
