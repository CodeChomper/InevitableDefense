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
var person
var healthbar
export (Color) var _warning = Color.yellow
export (Color) var _danger = Color.red
export (Color) var _good = Color.green
signal heli_died

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar = $HealthBar
	healthbar.value = health
	healthbar.tint_progress = _good
	var hud = get_parent().find_node("Hud")
	connect("heli_died", hud, "game_over")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	$AnimatedSprite.rotation_degrees = velocity.x * 0.02
	if weakref(person).get_ref():
		if person.ai_state == "on_heli":
			person.global_position = global_position
			person.global_position.y += 45
	pass

func shoot():
	can_shoot = false
	$Gun.play(0)
	var bullet = bullet_scene.instance()
	get_parent().add_child(bullet)
	
	bullet.position = global_position
	bullet.position.y += 5
	if going_left():
		bullet.position.x -= 42
		bullet.velocity *= -1
	else:
		bullet.position.x += 42
	
	pass
func get_input():
	if dead:
		return
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("down"):
		velocity.y += SPEED
	if Input.is_action_pressed("left"):
		if velocity.x > 0:
			velocity.x -= velocity.x / 8
		velocity.x -= SPEED
	if Input.is_action_pressed("right"):
		if velocity.x < 0:
			velocity.x -= velocity.x / 8
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
	healthbar.value = health
	if health <= 25:
		healthbar.tint_progress = _danger
	elif health <= 50:
		healthbar.tint_progress = _warning
	else:
		healthbar.tint_progress = _good
	if health <= 0:
		die()
	pass

func get_in_heli(person):
	self.person = person
	health = 100
	take_damage(0)
	#add_child(person)
	person.global_position = global_position
	person.global_position.y += 40
	pass

func die():
	emit_signal("heli_died")
	$DeathTimer.start(0.5)
	$Explosion.play(0)
	$Explosion_Sprite.visible = true
	$Explosion_Sprite.play("default")
	dead = true
	$AnimatedSprite.visible = false
	healthbar.visible = false

func _on_Overlaping_area_entered(area):
	if area.is_in_group('Sides'):
		velocity.x *= -1
	if area.is_in_group('Roof'):
		velocity.y *= -1
	pass # Replace with function body.


func _on_CanShoot_timeout():
	can_shoot = true
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	$Explosion_Sprite.visible = false
	pass # Replace with function body.
