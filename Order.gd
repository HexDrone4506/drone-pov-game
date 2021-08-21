extends Node

class_name Order

onready var issue_timer = $IssueTimer
onready var logging_timer = $LoggingTimer

enum {AVAILABLE, ISSUED, REJECTED, ACTIVE, SATISFIED, FAILED, NOT_LOGGED, CLOSED}
var state = AVAILABLE

signal order_issued(order)
signal order_accepted(order)
signal order_rejected(order)

signal order_satisfied(order)
signal order_failed(order)
signal order_not_logged(order)
signal order_closed(order)

export var issue_time: float = 10.0
export var acceptance_code: int = 130
export var logging_code: int = 230

func issue():
	print("order issued")
	setup()
	state = ISSUED
	emit_signal("order_issued", self)
	issue_timer.start(issue_time)

func accept():
	print("order accepted")
	issue_timer.stop()
	start()
	state = ACTIVE
	emit_signal("order_accepted", self)

func reject():
	print("order rejected")
	stop_timers()
	cleanup()
	state = REJECTED
	emit_signal("order_rejected", self)

func satisfy():
	print("order satisfied")
	state = SATISFIED
	emit_signal("order_satisfied", self)
	logging_timer.start()

func fail():
	stop_timers()
	cleanup()
	state = FAILED
	emit_signal("order_failed", self)

func fail_to_log():
	stop_timers()
	cleanup()
	state = NOT_LOGGED
	emit_signal("order_not_logged", self)

func close():
	stop_timers()
	cleanup()
	state = CLOSED
	emit_signal("order_closed", self)

func submit_acceptance_code(code):
	if code == acceptance_code and state == ISSUED:
		accept()
		return true
	else:
		return false

func submit_logging_code(code):
	if code == logging_code and state == SATISFIED:
		logging_timer.stop()
		close()
		return true
	else:
		return false

func stop_timers():
	issue_timer.stop()
	logging_timer.stop()

func issue_text():
	pass

func setup():
	pass

func start():
	pass

func cleanup():
	pass

func input_hexcode(_code):
	pass

func _on_LoggingTimer_timeout():
	fail_to_log()

func _on_IssueTimer_timeout():
	reject()
