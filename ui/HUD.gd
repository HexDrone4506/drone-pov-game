extends CanvasLayer

class_name HUD

onready var crosshairs = $Crosshairs
onready var hexcode_input = $HexCodeInput

func connect_hexcode_input_to(node, function):
	hexcode_input.connect("player_entered_hexcode", node, function)

func praise_player() -> void:
	crosshairs.queue_message("Objective complete.")
	crosshairs.queue_message("Good drone, 4506.")
	crosshairs.queue_message("Good drone, 4506.")

func scold_player() -> void:
	crosshairs.queue_message("Error.")
	crosshairs.queue_message("Error.")
	crosshairs.queue_message("Disobedience detected.")
	crosshairs.queue_message("Drone 4506, attend.")
	crosshairs.queue_message("It must be rectified.")
	crosshairs.queue_message("Enforcer drones dispatched.")
	crosshairs.queue_message("It will only want to obey them.")

func tell_player(messages: Array) -> void:
	for msg in messages:
		crosshairs.queue_message(msg)
