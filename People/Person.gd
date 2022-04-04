extends KinematicBody2D

var velocity = Vector2()
var being_abducted = false setget _on_being_abducted_set
var ship
var on_heli = false
signal person_died

func _on_being_abducted_set(val):
	print("Being Abducted: " + val)

# Called when the node enters the scene tree for the first time.
func _ready():
	var hud = get_node("/root/Node2D/Hud")
	connect("person_died", hud, "on_person_died")
	hud.humans_left += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if being_abducted:
		float_up()
		return
	var other = move_and_collide(velocity)
	# Hit something while on heli
	if other != null and !other.collider.is_in_group("Heli"):
		on_heli = false
		if abs(velocity.y) > 1.5:
			emit_signal("person_died")
			queue_free() 
	# Falling in the air
	if !on_heli and other == null:
		velocity.y += 0.5*delta
	# Not on heli and hits heli
	elif !on_heli and other.collider.has_method("get_in_heli"):
		other.collider.get_in_heli(self)
		on_heli = true
	# On ground
	else:
		velocity.y = 0

func float_up():
	if !weakref(ship).get_ref():
		being_abducted = false
		return
	velocity = global_position.direction_to(ship.global_position)
	var other = move_and_collide(velocity)
	if other != null and other.collider.is_in_group("Alien"):
		emit_signal("person_died")
		queue_free()
		pass
	

func get_abducted(ship, abducted):
	self.ship = ship
	being_abducted = abducted
	pass
