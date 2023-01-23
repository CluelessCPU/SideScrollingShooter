extends ParallaxLayer


export (float) var scroll_speed = 100.0
export (float) var scroll_speed_increment = 1.0
export var scrolling = true

var current_scroll_speed = 0

# Called when the node enters the scene tree for the first time.

func _process(delta):
	if scrolling:
		motion_offset.x -= current_scroll_speed * delta

func scrolling_start():
	while current_scroll_speed < scroll_speed:
		current_scroll_speed += scroll_speed_increment
		$IncrementTimer.start()
		yield($IncrementTimer, "timeout") 

func scrolling_stop():
	while current_scroll_speed > 0:
		current_scroll_speed -= scroll_speed_increment
		$IncrementTimer.start()
		yield($IncrementTimer, "timeout")
