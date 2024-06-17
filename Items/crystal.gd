extends ItemBase


@export var id : int
@export var camera : Camera3D
@export var cam_timer : Timer


func crystal_appear() -> void:
	appear()
	cam_timer.start()
	self.camera.current = true
	Global.pause_entities()


func _on_timer_timeout() -> void:
	self.camera.current = false
	Global.unpause_entities()


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered(body)
	self.queue_free()
