extends Control

class_name HexCodeInput

const PERMITTED_DIGITS := {
	KEY_0: 0, KEY_1: 1, KEY_2: 2, KEY_3: 3, KEY_4: 4, KEY_5: 5,
	KEY_6: 6, KEY_7: 7, KEY_8: 8, KEY_9: 9
}

const VALID_HEX_CODES := {
	130: "130 :: Status :: Directive commencing.",
	230: "230 :: Status :: Directive complete."
}

signal player_entered_hexcode(code, message)
signal player_entered_bad_hexcode

onready var reset_timer: Timer = $ResetTimer
onready var label: Label = $Label
onready var scroll_message: ScrollingMessage = $ScrollingMessage
onready var msgplayer: AnimationPlayer = $ScrollingMessage/AnimationPlayer

var hex_code: int = 0
var digits_recorded: int = 0

func reset() -> void:
	label.text = "___"
	digits_recorded = 0
	hex_code = 0

func process_code() -> void:
	if hex_code in VALID_HEX_CODES:
		var message = VALID_HEX_CODES[hex_code] as String
		scroll_message.play_message("4506 :: " + message)
		# Optional: Makes wait for animation to stop before emitting hexcode.
		yield(msgplayer, "animation_finished") 
		emit_signal("player_entered_hexcode", hex_code, message)
	else:
		emit_signal("player_entered_bad_hexcode")
	reset()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode in PERMITTED_DIGITS:
		if event.pressed and not event.is_echo():
			var digit := PERMITTED_DIGITS[event.scancode] as int
			hex_code = hex_code * 10 + digit
			digits_recorded += 1
			label.text[digits_recorded - 1] = str(digit)
			if digits_recorded < 3:
				reset_timer.start()
			else:
				# TODO: check the hexcodes and such.
				reset_timer.stop()
				process_code()

func _on_Timer_timeout():
	reset()
