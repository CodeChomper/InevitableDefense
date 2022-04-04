extends KinematicBody2D

var velocity = Vector2()
var ai_state = "falling" # falling beign_abducted on_heli walking
var ship
var WALK_SPEED = 20
signal person_died


# Called when the node enters the scene tree for the first time.
func _ready():
	var hud = get_node("/root/Node2D/Hud")
	connect("person_died", hud, "on_person_died")
	hud.humans_left += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var prev_velocity = velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if ai_state == "being_abducted" and weakref(ship).get_ref():
		velocity = global_position.direction_to(ship.global_position) * 30
		return
	
	if ai_state == "falling":
		velocity.y += 0.75
	
	if is_on_floor():
		if prev_velocity.y > 90 and ai_state != "on_heli":
			die()
			return
		ai_state = "walking"
		if abs(velocity.x) < 0.2:
			velocity.x = WALK_SPEED
	elif !ai_state == "on_heli":
		ai_state = "falling"
	
	if is_on_wall() and ai_state == "walking":
		velocity.x = -prev_velocity.x
	pass

func float_up(delta):
	if weakref(ship).get_ref():
		velocity = global_position.direction_to(ship.global_position) * delta * 35
	pass

func get_abducted(ship):
	self.ship = ship
	if ship != null:
		ai_state = "being_abducted"
	else:
		ai_state = "falling"
	pass

func die():
	emit_signal("person_died")
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Heli") and ai_state == "falling":
		print("hit heli")
		area.get_parent().get_in_heli(self)
		ai_state = "on_heli"
	if area.is_in_group("Alien"):
		print("hit alien")
		die()
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
	pass # Replace with function body.
