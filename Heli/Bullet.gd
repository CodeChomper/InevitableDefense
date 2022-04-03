extends KinematicBody2D

export (float) var SPEED = 10
var velocity = Vector2(SPEED, 0)

func _physics_process(delta):
	var other = move_and_collide(velocity)
	
	if other != null:
		if other.collider.has_method("take_damage"):
			other.collider.take_damage(10)
			print("delt damage")
		print("hit")
		queue_free()
	


func _on_VisibilityNotifier2D_screen_exited():
	print("off screen")
	queue_free()
	pass # Replace with function body.
