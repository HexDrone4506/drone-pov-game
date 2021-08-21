extends Spatial

class_name Level

onready var player = $Player
onready var order_system = $OrderSystem
onready var hud = $HUD

func _ready():
	order_system.connect("order_rejected", self, "_on_order_rejected")
	order_system.connect("order_failed", self, "_on_order_failed")
	order_system.connect("order_not_logged", self, "_on_order_not_logged")
	order_system.connect("order_closed", self, "_on_order_closed")
	$HUD/HexCodeInput.connect("player_entered_hexcode", self, "_on_player_hexcode")
	
	print("playing message")
	var order = order_system.get_next_order_ref()
	yield(hud.play_message_in_crosshair(order.issue_text()), "completed")
	print("done")
	print("issueing")
	order_system.issue_order(order)
	
func _on_order_rejected(_order):
	hud.play_message_in_crosshair(PoolStringArray(["Error.", "Error.", "Order not acknowleged."]))

func _on_order_failed(_order):
	hud.play_message_in_crosshair(PoolStringArray(["Error.", "Error.", "Order failed.", "Prepare for readjustment."]))

func _on_order_not_logged(_order):
	hud.play_message_in_crosshair(PoolStringArray(["Error.", "Error.", "Order not logged."]))

func _on_order_closed(_order):
	hud.play_message_in_crosshair(PoolStringArray(["Protocol Complete.", "Good Drone.", "Good Drone."]))

func _on_player_hexcode(code):
	print("on player hexcode")
	order_system.recieve_hexcode(code)
