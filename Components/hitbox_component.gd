extends Area3D
class_name HitboxComponent


@export var health_component : HealthComponent


func damage_dealt(attack : AttackComponent):
	#print("attack entered hitbox")
	if health_component:
		health_component.take_damage(attack)

