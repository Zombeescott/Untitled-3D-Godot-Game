extends Area3D
class_name JumppadComponent


@export var type: String
@export var strength: float


func _on_body_entered(body: Node3D) -> void:
	if body.get_groups().has("entity"):
		body.interaction_occured(self)
