extends CharacterBody3D
class_name EnemyBase


@export var attack : AttackComponent
@export var path : RemoteTransform3D

@export var type: String
@export var jump_strength: float
@export var animate: AnimationPlayer


func update(health : HealthComponent):
	if health.health <= 0:
		# Disable ability to damage
		attack.queue_free()
		if animate:
			animate.play("Die")
		else:
			self.queue_free()


func anim_complete(anim_name: StringName) -> void:
	match anim_name:
		"Die":
			self.queue_free()
	
