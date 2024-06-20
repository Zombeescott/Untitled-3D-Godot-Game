extends Area3D
class_name AttackComponent


@export var damage: float = 1


func _on_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		if !area.get_parent().is_ancestor_of(self):
			var hitbox : HitboxComponent = area
			hitbox.damage_dealt(self)

