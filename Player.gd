extends KinematicBody

class_name Player

export var speed := 10.0
export var acceleration := 5.0
export var mouse_sensitivity := 0.3
export var gravity := 0.98

onready var raycast := $RayCast
onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("drones", "set_player", self)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta
	

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	var direction := Vector3()
	
	if Input.is_action_pressed("move_forwards"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	velocity = move_and_slide(velocity)
	
	#move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	#move_and_collide(move_vec * MOVE_SPEED * delta)
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if raycast.is_colliding():
		var col = raycast.get_collider()
		if col is Drone:
			return
