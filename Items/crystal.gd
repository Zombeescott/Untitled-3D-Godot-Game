extends Node3D


@export var camera : Camera3D
@export var item_id : int = 0
@export var cam_timer : Timer


func crystal_appear() -> void:
	self.get_child(0).monitoring = true
	self.get_child(0).monitorable = true
	self.visible = true
	self.camera.current = true
	cam_timer.start()


func _on_timer_timeout() -> void:
	self.camera.current = false
