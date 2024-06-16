extends Node3D
class_name ItemBase


@export var item_type : String
@export var item_id : int = 0


func body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Global.curr_level:
			Global.curr_level.item_collected(item_type, item_id)
		else:
			Global.item_collected(item_type)
		body.item_collected() # Update UI
		
		self.queue_free()