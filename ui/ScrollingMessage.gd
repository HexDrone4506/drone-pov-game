extends Label

class_name ScrollingMessage

onready var message_player = $AnimationPlayer
onready var timer = $Timer

var message_queue = []
var playing_messages = false

func queue_message(msg):
	message_queue.push_back(msg)
	if not playing_messages:
		playing_messages = true
		play_message(message_queue.pop_front())

func play_message(msg):
	text = msg
	message_player.play("show_message")
	timer.start()

func clear_message():
	visible = false

func _on_Timer_timeout():
	clear_message()
	if message_queue.empty():
		playing_messages = false
	else:
		play_message(message_queue.pop_front())
