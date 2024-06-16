extends ItemBase


@export var camera : Camera3D
@export var cam_timer : Timer
@export var area : Area3D


func crystal_appear() -> void:
	area.monitoring = true
	#area.monitorable = true
	self.visible = true
	self.camera.current = true
	cam_timer.start()

func hide_crystal() -> void:
	area.monitoring = false
	#area.monitorable = false
	visible = false


func _on_timer_timeout() -> void:
	self.camera.current = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	body_entered(body)
