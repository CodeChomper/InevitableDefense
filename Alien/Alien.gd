extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var heli
var _health = 100
var velocity = Vector2()
var shoot_heli = false
var lazer_scene = load("res://Alien/Laser.tscn")
var can_shoot = false

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
	if heli != null and global_position.distance_to(heli.global_position) < 500:
		# follow player
		velocity = global_position.direction_to(heli.global_position)
		velocity *= 1.25
		pass
	if velocity.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	if can_shoot and shoot_heli:
		shoot()
	
	move_and_collide(velocity)
#	pass

func shoot():
	can_shoot = false
	var lazer = lazer_scene.instance()
	lazer.global_position = global_position
	lazer.velocity = velocity * 2
	var rot = global_position.angle_to(heli.global_position)
	lazer.turn_towards(rot)
	get_parent().add_child(lazer)
	pass


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
