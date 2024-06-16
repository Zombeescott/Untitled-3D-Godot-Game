extends Node3D
class_name HealthComponent


@export var group: String = ""
@export var MAX_HEALTH:  int = 100
var health : float


func _ready() -> void:
	health = MAX_HEALTH


func take_damage(attack : AttackComponent):
	health -= attack.damage
	if Global.curr_level:
		Global.curr_level.interaction_occured(group)
	
	# Tell parent it was hit
	if get_parent().has_method("update"):
		get_parent().update(self)
	#else:
	#	get_parent().queue_free()
