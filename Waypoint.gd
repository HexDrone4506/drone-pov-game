extends Spatial

class_name Waypoint

signal player_arrived

func _on_Area_body_entered(body):
	if body is Player:
		emit_signal("player_arrived")
		queue_free()
