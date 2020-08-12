extends Node

export (PackedScene) var Mob
var score

######################################
# NOTES FROM YESTERDAY (TUESDAY)
# You got up to 'Testing the Scene'
######################################

func _ready():
	randomize()
	#new_game() #temp call for testing, remove me

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	# the player's hit signal is connected here
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()

func new_game():
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")


func _on_MobTimer_timeout():
	# as this timer expires it creates a new mob to send across the screen
	# the velocity is randomised
	
	# the spawn location is chosen from MobPath, which automatically rotates
	$MobPath/MobSpawnLocation.offset = randi()
	# instance a new mob
	var mob = Mob.instance()
	add_child(mob)
	
	# set direction perpendicular to path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# set position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	# add some randomness to the direction
	direction += rand_range(-PI / 4, PI /4)
	mob.rotation = direction
	
	# set mob velocity randomly
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

# PI represents radians

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
