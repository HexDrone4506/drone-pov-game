extends Order

onready var timer = $Timer

export var destination: Vector3 = Vector3.ZERO
export var time_limit: float = 10.0
export var waypoint_path: NodePath

var waypoint: Waypoint

# Overloads of virtual methods from Order class:

func issue_text() -> PoolStringArray:
	var arr = PoolStringArray()
	arr.append("Drone 4506, attend.")
	arr.append("Goto to target marker.")
	return arr

func setup():
	waypoint = preload("res://Waypoint.tscn").instance()
	waypoint.translate(destination)
	waypoint.connect("player_arrived", self, "_on_player_arrived")
	
	# TODO: I don't know if there's a better way for an order object to spawn
	# in world entities than this.
	get_node(waypoint_path).add_child(waypoint)

func start():
	timer.start(time_limit)

func cleanup():
	if is_instance_valid(waypoint):
		waypoint.queue_free()

# Specific methods to GotoOrder.

func _on_player_arrived():
	print("player arrived")
	match state:
		ISSUED:
			reject()
		ACTIVE:
			timer.stop()
			satisfy()
		_:
			print("failing for some unknown reason, marker was hit not in ISSUED or ACTIVE states")
			fail()

func _on_Timer_timeout():
	fail()
