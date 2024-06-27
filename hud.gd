extends CanvasLayer

signal start_game

# displaying a message temporarily (like "Get ready!" or something)
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


# processing what happens when the player loses
func show_game_over():
	show_message("Game over")
	
	# wait until the MessageTimer has counted down
	await $MessageTimer.timeout

	$Message.text = "ROCKETTACK!"
	$Message.show()
	
	$Message2.text = "use the arrow keys to move"
	$Message2.show()
	
	# make a one shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


# updating the score
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
	$Message2.hide()
