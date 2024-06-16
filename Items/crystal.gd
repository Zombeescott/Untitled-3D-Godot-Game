extends ItemBase


@export var camera : Camera3D
@export var cam_timer : Timer


func crystal_appear() -> void:
	appear()
	cam_timer.start()
	self.camera.current = true


func _on_timer_timeout() -> void:
	self.camera.current = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered(body)
	self.queue_free()
