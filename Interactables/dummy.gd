extends CharacterBody3D


@onready var label : Label3D = $"Health label"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update(health : HealthComponent):
	label.text = str(health.health)
