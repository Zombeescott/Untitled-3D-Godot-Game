extends Node3D


@export var checkpoints : Array[Node3D]
@export var win_time : float
@export var dev_time : float

var curr_point : int
var started : bool = false
var elapsed_time : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if checkpoints:
		for node in checkpoints:
			node.race_start = self
	else:
		for node in self.get_children():
			if !(node is Area3D):
				node.race_start = self
				checkpoints.append(node)


func _process(delta: float) -> void:
	if started:
		elapsed_time += delta
		Global.update_timer(round(elapsed_time * 100) / 100.0)


func _on_area_3d_body_entered(body: Node3D) -> void:
	elapsed_time = 0
	checkpoints[curr_point].disappear()
	curr_point = 0
	checkpoints[curr_point].appear()
	started = true


func checkpoint_entered() -> void:
	checkpoints[curr_point].disappear()
	curr_point += 1
	if curr_point < checkpoints.size():
		checkpoints[curr_point].appear()
	else:
		started = false
		curr_point = 0
		Global.timer_remove()
		if Global.curr_level:
			if elapsed_time <= win_time and elapsed_time > dev_time:
				Global.interface.set_timer_color("green")
			elif elapsed_time <= dev_time:
				Global.interface.set_timer_color("blue")
			else:
				Global.interface.set_timer_color("red")
				return
		
			Global.curr_level.interaction_occured("race")
