extends Spatial

onready var timer = $Timer

signal player_arrived
signal timeup

func _ready():
	timer.start()

func _on_Area_body_entered(body):
	if body is Player:
		emit_signal("player_arrived")
		queue_free()

func _on_Timer_timeout():
	emit_signal("timeup")
	queue_free()
