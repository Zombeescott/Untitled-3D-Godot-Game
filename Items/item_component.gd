extends Node3D


@export var item_type : String = "coin" 


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.item_collected(item_type)
		body.item_collected()
		
		queue_free()
