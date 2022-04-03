extends KinematicBody2D

var velocity = Vector2()
var being_abducted = false
var ship
var on_heli = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if being_abducted:
		float_up()
		return
	var other = move_and_collide(velocity)
	if other != null and !other.collider.is_in_group("Heli"):
		on_heli = false
	if !on_heli and other == null:
		velocity.y += 1*delta
	elif !on_heli and other.collider.has_method("get_in_heli"):
		other.collider.get_in_heli(self)
		#$ObjectCollider.disabled = true
		on_heli = true
	else:
		velocity.y = 0

func float_up():
	if !weakref(ship).get_ref():
		being_abducted = false
		return
	velocity = global_position.direction_to(ship.global_position)
	var other = move_and_collide(velocity)
	if other != null and other.collider.is_in_group("Alien"):
		queue_free()
		pass
	

func get_abducted(ship):
	self.ship = ship
	being_abducted = true
	print("I am being abuducted!")
	pass
