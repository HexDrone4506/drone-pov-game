extends Node

class_name Order

signal new_order(order)
signal order_not_accepted(order)
signal order_accepted(order)
signal order_complete(order)
signal order_failed(order)

export var acceptance_code  = 130
export var compleition_code = 230

var player_accepted = false

func prepare_order(level):
	

func on_player_hexcode(code):
	pass




func _on_AcceptanceTimer_timeout():
	emit_signal("order_not_accepted", self)
