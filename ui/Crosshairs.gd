extends Control

onready var message = $Message
onready var message_player = $MessagePlayer

var message_queue = []
var message_to_play = []
var playing_messages = false

export var message_show_time := 2.0

func queue_message(msg):
	message_queue.push_back(msg)
	if not playing_messages:
		playing_messages = true
		play_message(message_queue.pop_front())

func play_message(msg: PoolStringArray):
	for m in msg:
		yield(play_string(m), "completed")
	print("Finished msgplay")

func play_string(s: String):
	message.text = s
	message_player.play("show_message")
	yield(get_tree().create_timer(message_show_time), "timeout")
	clear_message()

func clear_message():
	message.visible = false
