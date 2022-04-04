extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var heli
var _health = 100
var velocity = Vector2(40, 0)
var shoot_heli = false
var lazer_scene = load("res://Alien/Laser.tscn")
var can_shoot = false
var ai_state = ""
var updown = 0
var prev_x_velocity = 0
var can_abduct = false
var hud
signal alien_died

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_node("/root/Node2D/Hud")
	hud.enemies_left += 1
	connect("alien_died", hud, "on_alien_died")
	heli = get_parent().find_node("Heli")
	pass # Replace with function body.

func take_damage(damage):
	_health -= damage
	if _health <= 0:
		die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if velocity.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	move_and_slide(velocity)
	
	if ai_state == "patrol":
		patrol(delta)
	elif ai_state == "attack":
		attack()
	elif ai_state == "abduct":
		abduct()
	
	if heli != null and !heli.dead and global_position.distance_to(heli.global_position) < 500:
		self.ai_state = "attack"
	else:
		self.ai_state = "patrol"

func abduct():
	$BeamSprite.visible = true
	velocity = Vector2()

func patrol(delta):
	# look for people
	# move up and down
	updown += delta / 4
	var freq = 1
	var amplitude = 40
	velocity.y = cos(updown*freq)*amplitude

func attack():
	# follow player
	if $BeamSprite.visible:
		velocity.x = 0
	else:
		velocity = global_position.direction_to(heli.global_position)
		velocity *= 60
	if can_shoot and shoot_heli:
		shoot()

func shoot():
	var v = global_position.direction_to(heli.global_position)
	can_shoot = false
	var lazer = lazer_scene.instance()
	lazer.global_position = global_position
	lazer.velocity = v * 2
	var rot = global_position.angle_to(heli.global_position)
	lazer.turn_towards(rot)
	get_parent().add_child(lazer)
	pass

func _on_Bump_area_entered(area):
	if area.is_in_group('Sides'):
		velocity.x *= -1
	if area.is_in_group('Roof'):
		velocity.y *= -1

func die():
	emit_signal("alien_died")
	$Explosion.play(0)
	can_abduct = false
	$Sprite.visible = false
	$CollisionPolygon2D.disabled = true
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("default")
	$DeathTimer.start(0.5)


func _on_HeliShootZone_area_entered(area):
	shoot_heli = true
	pass # Replace with function body.


func _on_HeliShootZone_area_exited(area):
	shoot_heli = false
	pass # Replace with function body.


func _on_CanShoot_timeout():
	can_shoot = true
	pass # Replace with function body.


func _on_ChangePatrolDir_timeout():
	var switch_dir = rand_range(0, 100)
	if switch_dir > 50:
		velocity.x *= -1


func _on_Beam_area_entered(area):
	if can_abduct:
		ai_state = "abduct"
		prev_x_velocity = velocity.x
		if area.get_parent().has_method("get_abducted"):
			area.get_parent().get_abducted(self)
			print("Found PERSON!!!!")
	pass # Replace with function body.


func _on_Beam_area_exited(area):
	if area.get_parent().has_method("get_abducted"):
		area.get_parent().get_abducted(null)
		$BeamSprite.visible = false
		velocity.x = prev_x_velocity
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	can_abduct = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	can_abduct = false
	pass # Replace with function body.


func _on_DeathTimer_timeout():
	queue_free()
	pass # Replace with function body.
