extends Control

onready var message = $Message
onready var message_player = $MessagePlayer
onready var message_timer = $MessageTimer

var message_queue = []
var playing_messages = false

func queue_message(msg):
	message_queue.push_back(msg)
	if not playing_messages:
		playing_messages = true
		play_message(message_queue.pop_front())

func play_message(msg):
	message.text = msg
	message_player.play("show_message")
	message_timer.start()

func clear_message():
	message.visible = false

func _on_MessageTimer_timeout():
	clear_message()
	if message_queue.empty():
		playing_messages = false
	else:
		play_message(message_queue.pop_front())
