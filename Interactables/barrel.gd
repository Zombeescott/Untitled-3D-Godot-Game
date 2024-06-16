extends Node3D

@export var label: Label3D

func _process(delta: float) -> void:
	# When text is set, the size slowly increases
	if label.text:
		label.scale *= 1.001

func update_label() -> void:
	var total = Global.curr_level.num_barrels
	var broken = Global.curr_level.broken_barrels
	label.text = str(broken, "/", total)


func _on_gpu_particles_3d_finished() -> void:
	queue_free()
