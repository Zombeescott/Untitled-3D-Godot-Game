extends CharacterBody3D


@onready var label : Label3D = $"Health label"


func update(health : HealthComponent):
	label.text = str(health.health)
