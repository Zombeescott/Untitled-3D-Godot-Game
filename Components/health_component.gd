extends Node3D
class_name HealthComponent


@export var MAX_HEALTH:  int = 100
var health : float


func _ready() -> void:
	health = MAX_HEALTH


func take_damage(attack : AttackComponent):
	health -= attack.damage
	
	# Tell parent it was hit
	if get_parent().has_method("update"):
		get_parent().update(self)
	if health <= 0:
		get_parent().queue_free()
