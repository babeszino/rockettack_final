extends Node

@export var rocket_scene: PackedScene
var score

# bg size for mirroring
var background_size = Vector2(1024, 682)

# parallax bg scroll speeds
var scroll_speeds = [Vector2(0,0), Vector2(-50, 0), Vector2(-100, 0)]

func _ready():
	for i in range($ParallaxBackground.get_child_count()):
		var layer = $ParallaxBackground.get_child(i)
		layer.motion_mirroring = background_size


func _process(delta):
	for i in range($ParallaxBackground.get_child_count()):
		var layer = $ParallaxBackground.get_child(i)
		layer.motion_offset += scroll_speeds[i] * delta


func game_over():
	$ScoreTimer.stop()
	$RocketTimer.stop()
	
	$HUD.show_game_over()


func new_game():
	score = 0
	$Plane.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$RocketTimer.start()
	$ScoreTimer.start()


func _on_rocket_timer_timeout():
	# creating a new instance of the Rocket scene
	var rocket = rocket_scene.instantiate()
	
	# choosing a random location on Path2D
	var rocket_spawn_location = $RocketPath/RocketSpawnLocation
	rocket_spawn_location.progress_ratio = randf()
	
	# setting the rocket's direction perpendicular to the path direction
	var direction = rocket_spawn_location.rotation + PI / 2
	
	# setting the rocket's position to a random location
	rocket.position = rocket_spawn_location.position
	
	# adding some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	rocket.rotation = direction
	
	# choosing the velocity for the rocket
	var velocity = Vector2(randf_range(150.0, 500.0), 0.0)
	rocket.linear_velocity = velocity.rotated(direction)

	add_child(rocket)
