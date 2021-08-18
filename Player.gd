extends KinematicBody

class_name Player

signal emit_code(code)

const MOVE_SPEED = 2
const MOUSE_SENS = 0.5

onready var raycast := $RayCast
#onready var hud := $HUD
#onready var crosshairs := $HUD/Crosshairs

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("drones", "set_player", self)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x

func _physics_process(delta):
	var move_vec := Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if raycast.is_colliding():
		var col = raycast.get_collider()
		if col is Drone:
			return

#func connect_hexcode_input_to(node, function):
#	hud.connect_hexcode_input_to(node, function)
