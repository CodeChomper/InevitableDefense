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
# Called when the node enters the scene tree for the first time.
func _ready():
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
	velocity = move_and_slide(velocity)
	
	if ai_state == "patrol":
		patrol(delta)
	elif ai_state == "attack":
		attack()
	else:
		print(ai_state)
	
	if heli != null and !heli.dead and global_position.distance_to(heli.global_position) < 500:
		self.ai_state = "attack"
	else:
		self.ai_state = "patrol"

func patrol(delta):
	# look for people
	
	
	# move up and down
	var v = Vector2(0,0)
	updown += delta
	var freq = 1
	var amplitude = 20
	velocity.y = cos(updown*freq)*amplitude
	#velocity = move_and_slide(velocity)
	
	

func attack():
	# follow player
	velocity = global_position.direction_to(heli.global_position)
	velocity *= 60
	if can_shoot and shoot_heli:
		shoot()
	
	

func abduct():
	pass

func shoot():
	can_shoot = false
	var lazer = lazer_scene.instance()
	lazer.global_position = global_position
	lazer.velocity = velocity / 20
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
	queue_free()


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
