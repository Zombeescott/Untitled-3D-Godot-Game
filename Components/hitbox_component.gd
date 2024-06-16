extends Area3D
class_name HitboxComponent


@export var health_component : HealthComponent
@export var particles : GPUParticles3D
@export var label : bool


func damage_dealt(attack : AttackComponent):
	if particles:
		particles.emitting = true
	if health_component:
		health_component.take_damage(attack)
		
		if label:
			get_parent().update_label()
		
		if health_component.health <= 0:
			queue_free()
