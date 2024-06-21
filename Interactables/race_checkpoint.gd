extends Node3D


var race_start


func _on_area_3d_body_entered(body: Node3D) -> void:
	race_start.checkpoint_entered()


func appear() -> void:
	self.visible = true
	self.get_child(0).set_deferred("monitoring", true)
	self.get_child(0).set_collision_layer_value(1, true)


func disappear() -> void:
	self.visible = false
	self.get_child(0).set_deferred("monitoring", false)
	self.get_child(0).set_collision_layer_value(1, false)
