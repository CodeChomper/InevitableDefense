extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func turn_towards(angle):
	$Sprite.rotate(velocity.angle())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var other = move_and_collide(velocity)
	if other != null:
		if other.collider.has_method("take_damage"):
			other.collider.take_damage(25)
			print("delt damage")
		
		queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sides"):
		queue_free()
	pass # Replace with function body.
