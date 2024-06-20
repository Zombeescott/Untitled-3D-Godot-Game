extends Control


@export var health_container : ColorRect
@onready var heart = load("res://Textures/Shadow.png")
@onready var empty_heart = load("res://Textures/Tile_07-128x128.png")


func update_ui() -> void:
	if Global.curr_level:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count, "/", Global.curr_level.num_coins)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count, "/", Global.curr_level.num_crystals)
	else:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count)
	

func update_health(health : HealthComponent) -> void:
	for i in health_container.get_child_count():
		if i < health.health:
			health_container.get_child(i).texture = heart
		else:
			health_container.get_child(i).texture = empty_heart
