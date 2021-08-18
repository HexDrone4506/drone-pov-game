extends Spatial

onready var march_order = $MarchOrder
onready var player = $Player

func _ready():
	print("Marchorder ready")
	march_order.setup(player, Vector3(0.518, -0.379, -0.588), 10.0)

func _on_MarchOrder_march_order_complete():
	player.praise_player()

func _on_MarchOrder_march_order_failed():
	player.scold_player()

func _on_MarchOrder_new_march_order(destination : Vector3):
	print("Walk to location [X: %s, Y: %s, Z: %s]." % [destination.x, destination.y, destination.z])
	player.tell_player([
		"Drone 4506, attend.",
		"Goto to target marker."
	])
