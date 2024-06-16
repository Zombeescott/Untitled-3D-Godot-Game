extends ItemBase


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered(body)
	self.queue_free()
