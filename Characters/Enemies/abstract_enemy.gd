extends CharacterBody3D
class_name EnemyBase


@export var attack : AttackComponent
@export var path : RemoteTransform3D

@export var type: String
@export var jump_strength: float
@export var animate: AnimationPlayer

var dying : bool = false


func update(health : HealthComponent):
	if health.health <= 0 and !dying:
		# dying bool is temp until death animation in snail is figured out
		# or a solution to disable monitoring of hitbox area is made idk
		dying = true
		
		# Disable ability to damage
		if attack:
			attack.queue_free()
		if animate:
			animate.play("Die")
		else:
			self.queue_free()


func anim_complete(anim_name: StringName) -> void:
	match anim_name:
		"Die":
			self.queue_free()
	
