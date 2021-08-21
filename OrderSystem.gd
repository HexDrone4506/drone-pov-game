extends Node

class_name OrderSystem

onready var available_orders = $AvailableOrders
onready var active_orders = $ActiveOrders

onready var issued_orders = $IssuedOrders
onready var rejected_orders = $RejectedOrders

onready var unfulfilled_orders = $UnfulfilledOrders
onready var satisfied_orders = $SatisfiedOrders

onready var unlogged_orders = $UnloggedOrders
onready var closed_orders = $ClosedOrders

signal order_issued(order)
signal order_accepted(order)
signal order_rejected(order)

signal order_satisfied(order)
signal order_failed(order)
signal order_not_logged(order)
signal order_closed(order)

func _ready():
	for order in available_orders.get_children():
		connect_order(order)

func connect_order(order):
	order.connect("order_rejected", self, "_on_order_rejected")
	order.connect("order_accepted", self, "_on_order_accepted")
	order.connect("order_satisfied", self, "_on_order_satisfied")
	order.connect("order_failed", self, "_on_order_failed")
	order.connect("order_not_logged", self, "_on_order_not_logged")
	order.connect("order_closed", self, "_on_order_closed")
	order.connect("order_issued", self, "_on_order_issued")

func _on_order_issued(order):
	available_orders.remove_child(order)
	issued_orders.add_child(order)
	emit_signal("order_issued", order)

func _on_order_rejected(order):
	issued_orders.remove_child(order)
	rejected_orders.add_child(order)
	emit_signal("order_rejected", order)

func _on_order_accepted(order):
	issued_orders.remove_child(order)
	active_orders.add_child(order)
	emit_signal("order_accepted", order)

func _on_order_satisfied(order):
	active_orders.remove_child(order)
	satisfied_orders.add_child(order)
	emit_signal("order_satisfied", order)

func _on_order_failed(order):
	active_orders.remove_child(order)
	unfulfilled_orders.add_child(order)
	emit_signal("order_failed", order)

func _on_order_not_logged(order):
	satisfied_orders.remove_child(order)
	unlogged_orders.add_child(order)
	emit_signal("order_not_logged", order)

func _on_order_closed(order):
	satisfied_orders.remove_child(order)
	closed_orders.add_child(order)
	emit_signal("order_closed", order)

func get_next_order_ref():
	return available_orders.get_child(0)

func issue_order(order):
	if order in available_orders.get_children():
		order.issue()

func submit_acceptance_code(code):
	for issued_order in issued_orders.get_children():
		if issued_order.submit_acceptance_code(code):
			break

func submit_logging_code(code):
	for satisfied_order in satisfied_orders.get_children():
		if satisfied_order.submit_logging_code(code):
			break

func recieve_hexcode(code):
	print("recieving hexcode")
	match code:
		130, 131, 132, 133:
			submit_acceptance_code(code)
		230:
			submit_logging_code(code)
	for active_order in active_orders.get_children():
		active_order.input_hexcode(code)
