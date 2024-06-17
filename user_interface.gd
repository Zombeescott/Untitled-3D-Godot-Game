extends Control


func update_ui() -> void:
	$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count, "/", Global.curr_level.num_coins)
	$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count, "/", Global.curr_level.num_crystals)
