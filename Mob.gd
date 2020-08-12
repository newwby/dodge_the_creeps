extends RigidBody2D


export var min_speed = 150 # minimum value of speed range
export var max_speed = 250 # maximum value of speed range


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	# animation chosen from an array of the animation names
 # randi selects an integer between 0 and n-1
 # you must use randomize() to prevent the sequence of random numbers being different

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_exited():
	# connected screen_exited() signal to delete mobs after they leave the screen
	queue_free()
