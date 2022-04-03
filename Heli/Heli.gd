extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 9
var MAX_SPEED = 200
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	$AnimatedSprite.rotation_degrees = velocity.x * 0.02
	pass

func get_input():
	
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("down"):
		velocity.y += SPEED
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("right"):
		velocity.x += SPEED	
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	if velocity.x < 0:
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)


func _on_Overlaping_area_entered(area):
	if area.is_in_group('Sides'):
		velocity.x *= -1
	if area.is_in_group('Roof'):
		velocity.y *= -1
	pass # Replace with function body.
