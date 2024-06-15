extends Area3D


@export var item_type : String
@export var item_id : int = 0


func _ready() -> void:
	# I need to make this inheritance based over component this sucks
	if item_type == "crystal":
		item_id = self.get_parent().item_id

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Global.curr_level:
			Global.curr_level.item_collected(item_type, item_id)
		else:
			Global.item_collected(item_type)
		body.item_collected() # Update UI
		
		self.get_parent().queue_free()
