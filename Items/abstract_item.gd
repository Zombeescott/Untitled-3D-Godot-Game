extends Node3D
class_name ItemBase


@export var item_type : String
@export var area : Area3D
@export var appeared : bool = true


func _ready() -> void:
	if appeared == false:
		self.hide_item()


func body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Global.curr_level:
			Global.curr_level.item_collected(self)
		else:
			Global.item_collected(self)


func appear() -> void:
	self.get_child(0).set_deferred("monitoring", true)
	#self.get_child(0).monitorable = true
	area.visible = true
	self.visible = true
	area.set_collision_layer_value(1, true)


func hide_item() -> void:
	self.get_child(0).set_deferred("monitoring", false)
	#self.get_child(0).monitorable = false
	area.visible = false
	self.visible = false
	area.set_collision_layer_value(1, false)
