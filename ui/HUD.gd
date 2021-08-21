extends CanvasLayer

class_name HUD

onready var crosshairs = $Crosshairs
onready var hexcode_input = $HexCodeInput

func play_message_in_crosshair(msg):
	yield(crosshairs.play_message(msg), "completed")

func connect_hexcode_input_to(node, function):
	hexcode_input.connect("player_entered_hexcode", node, function)

func tell_player(messages: Array) -> void:
	for msg in messages:
		crosshairs.queue_message(msg)
