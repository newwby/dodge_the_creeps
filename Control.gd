extends Area2D
signal hit


export var speed = 400
var screen_size


func _ready():
	# find the size of the game window
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2() # Player's movement vector
	if Input.is_action_pressed("ui_right"): # has pressed right arrow key
		velocity.x += 1
	if Input.is_action_pressed("ui_left"): # has pressed left arrow key
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"): # has pressed down arrow key
		velocity.y += 1
	if Input.is_action_pressed("ui_up"): # has pressed up arrow key
		velocity.y -= 1
	
	 # diagonal movement would be faster than taxicab if not normalised
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play() # the $ sign means get_node()
	else:
		$AnimatedSprite.stop()
	
	# position value must be clamped; this means to restrict it to a certain range
	# in this case the clamped range is the dimensions of the screen size
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"  # x movement uses the walk animation
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0 # if true, we flip animation
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up" # y movement uses the up animation
		$AnimatedSprite.flip_v = velocity.y > 0 # if true, we flip animation


func _on_Player_body_entered(body):
	# this function executes if a rigidbody2D enters the player's space
	hide() # hides the player when hit
	emit_signal("hit") # emits the custom signal 'hit'
	$CollisionShape2D.set_deferred("disabled", true) # disable player collision so signal isn't repeatedly sent

"""Disabling the area's collision shape can cause an error if it happens in the
 middle of the engine's collision processing. Using set_deferred() tells Godot
to wait to disable the shape until it's safe to do so."""

func start(pos):
# this is a function to reset the player when starting a new game
	position = pos
	show()
	$CollisionShape2D.disabled = false

