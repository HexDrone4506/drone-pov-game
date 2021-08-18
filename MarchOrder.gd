extends Order

class_name MarchOrder

signal new_march_order(destination)
signal march_order_complete
signal march_order_failed

onready var acceptance_timer = $AcceptanceTimer
onready var confirmation_timer = $ConfirmationTimer

var player_did_startcode = false
var player_reached_destination = false

func setup(player: Player, destination: Vector3, time_limit: float):
	var waypoint = preload("res://Waypoint.tscn").instance()
	waypoint.translate(destination)
	waypoint.get_node("Timer").wait_time = time_limit
	waypoint.connect("player_arrived", self, "_on_player_arrived")
	waypoint.connect("timeup", self, "_on_player_timeup")
	
	# TODO: This should probably be replaced with a signal, that can be picked up by a main
	# game node or something higher in a scene tree that is in control of spawining entities.
	get_tree().get_root().get_node("Spatial").add_child(waypoint)
	# TODO: Ok this is probably a lil better.
	player.connect_hexcode_input_to(self, "_on_player_hexcode")
	
	emit_signal("new_march_order", destination)
	acceptance_timer.start()

func on_player_hexcode(code):
	if code == 130:
		# Just incase somehow the player completes task before the acceptance
		# timer runs out.
		player_did_startcode = true
		acceptance_timer.stop()
	if code == 230 and player_reached_destination:
		confirmation_timer.stop()
		emit_signal("march_order_complete")

func _on_player_hexcode(code, message):
	print(code)
	if code == 130:
		# Just incase somehow the player completes task before the acceptance
		# timer runs out.
		player_did_startcode = true
		acceptance_timer.stop()
	if code == 230 and player_reached_destination:
		confirmation_timer.stop()
		emit_signal("march_order_complete")

func _on_player_arrived():
	print("Player arrived")
	if player_did_startcode:
		player_reached_destination = true
		confirmation_timer.start()
	else:
		emit_signal("march_order_failed")

func _on_player_timeup():
	print("You loose sucker!")
	emit_signal("march_order_failed")

func _on_AcceptanceTimer_timeout():
	emit_signal("march_order_failed")

func _on_ConfirmationTimer_timeout():
	emit_signal("march_order_failed")
