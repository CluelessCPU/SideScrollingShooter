extends CanvasLayer

signal start_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Main_update_score(score):
	$ScoreLabel.text = ("Score: %s") % score


func _on_Player_health(new_health):
	$Healthbar.set_deferred("value", new_health)
	if new_health > 5:
		print("Health out of range. Max: 5, Got: %s" % new_health)


func _on_StartButton_pressed():
	emit_signal("start_level")
	$StartButton.hide()
	$QuitButton.hide()
	$MessageBanner.hide()
	$ScoreLabel.show()
	$Healthbar.show()
	
	
func game_over():
	$MessageBanner.show()
	$MessageBanner.text = "Game Over"
	$GameOverTimer.start()
	yield($GameOverTimer, "timeout")
	$ScoreLabel.hide()
	$MessageBanner.text = "Space War"
	$StartButton.show()
	$QuitButton.show()
	

func _on_QuitButton_pressed():
	get_tree().quit()
