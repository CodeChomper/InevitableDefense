extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var heli
var _health = 100
var velocity = Vector2()

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
	
	move_and_collide(velocity)
#	pass


func die():
	queue_free()
