extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 9
var MAX_SPEED = 200
var velocity = Vector2()
var can_shoot = false
var bullet_scene = load("res://Heli/Bullet.tscn")
var health = 100
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	$AnimatedSprite.rotation_degrees = velocity.x * 0.02
	pass

func shoot():
	can_shoot = false
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	
	bullet.position = global_position
	bullet.position.y += 5
	if going_left():
		bullet.position.x -= 42
		bullet.velocity *= -1
	else:
		bullet.position.x += 42
	
	print("shoot")
	pass

func get_input():
	if dead:
		return
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
	
	if going_left():
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)
	
	if can_shoot and Input.is_action_pressed("shoot"):
		shoot()

func going_left():
	return velocity.x < 0

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
	pass

func die():
	dead = true
	$AnimatedSprite.visible = false

func _on_Overlaping_area_entered(area):
	if area.is_in_group('Sides'):
		velocity.x *= -1
	if area.is_in_group('Roof'):
		velocity.y *= -1
	pass # Replace with function body.


func _on_CanShoot_timeout():
	can_shoot = true
	pass # Replace with function body.
