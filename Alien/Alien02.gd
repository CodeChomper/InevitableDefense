extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ai_state = "patrol"
var velocity = Vector2()
var side2side = 0
var heli
var health = 100
var hud
signal alien_died

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_parent().find_node("Hud")
	connect("alien_died", hud, "on_alien_died")
	hud.enemies_left += 1
	heli = get_parent().find_node("Heli")
	pass # Replace with function body.


func _physics_process(delta):
	if ai_state == "patrol":
		patrol(delta)
	elif ai_state == "attack":
		attack()
	var other = move_and_collide(velocity * delta)
	if other != null and other.collider.has_method("take_damage"):
		take_damage(100)
		other.collider.take_damage(100)
		
	pass

func patrol(delta):
	velocity.y = 0
	side2side += delta / 4
	var freq = 1
	var amplitude = 40
	velocity.x = cos(side2side*freq)*amplitude
	velocity.y = cos(side2side*freq)*amplitude
	pass

func attack():
	velocity = global_position.direction_to(heli.global_position) * 70
	pass

func _on_HeliDetector_area_entered(area):
	ai_state = "attack"
	pass # Replace with function body.


func _on_HeliDetector_area_exited(area):
	ai_state = "patrol"
	pass # Replace with function body.

func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	emit_signal("alien_died")
	$Explosion.play(0)
	$CollisionPolygon2D.disabled = true
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("default")
	$DeathTimer.start(0.5)


func _on_DeathTimer_timeout():
	queue_free()
	pass # Replace with function body.
