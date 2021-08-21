extends KinematicBody

class_name Drone

onready var bodysprite = $BodySprite

var player_ref = null
export var anim_col = 0

func set_player(p):
	player_ref = p

func display_sprite_based_on_player():
	if player_ref == null:
		return
	var p_fwd = -player_ref.global_transform.basis.z
	var fwd = global_transform.basis.z
	var left = global_transform.basis.x
	var l_dot = left.dot(p_fwd)
	var f_dot = fwd.dot(p_fwd)
	var row = 0
	bodysprite.flip_h = false
	if f_dot < -0.8:
		row = 0 # front sprite
	elif f_dot > 0.8:
		row = 4	# back sprite
	else:
		bodysprite.flip_h = l_dot > 0
		if abs(f_dot) < 0.3:
			row = 2 # left sprite
		elif f_dot < 0:
			row = 1 # forward left sprite.
		else:
			row = 3 # back left sprite.
	bodysprite.frame = anim_col + row * 3

	
# Callbacks

func _process(_delta):
	display_sprite_based_on_player()

func _ready():
	add_to_group("drones")
