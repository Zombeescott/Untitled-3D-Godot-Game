extends Node

var coin_count = 0
var star_count = 0

signal update_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func item_collected(item: String) -> void:
	match item:
		"coin":
			coin_count += 1
		"star":
			star_count += 1
	
	#update_ui.emit()
