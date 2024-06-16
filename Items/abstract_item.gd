extends Node3D
class_name ItemBase


@export var item_type : String
@export var item_id : int = 0
@export var area : Area3D


func body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Global.curr_level:
			Global.curr_level.item_collected(item_type, item_id)
		else:
			Global.item_collected(item_type)
		body.item_collected() # Update UI


func appear() -> void:
	#area.monitoring = true
	self.get_child(0).set_deferred("monitoring", true)
	#self.get_child(0).monitorable = true
	area.visible = true
	self.visible = true


func hide_item() -> void:
	#area.monitoring = false
	#self.get_child(0).monitoring = false
	self.get_child(0).set_deferred("monitoring", false)
	#self.get_child(0).monitorable = false
	area.visible = false
	self.visible = false
