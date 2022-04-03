extends KinematicBody2D

var max_opacity = 0
var _cur_opacity = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	max_opacity = rand_range(20, 200)
	$Sprite.modulate.a8 = _cur_opacity
	$Sprite2.modulate.a8 = _cur_opacity
	velocity.x = rand_range(1,50)
	var flip = round(rand_range(0,1))
	if(flip == 1):
		scale.x = 1
	else:
		scale.x = -1
	
	var z = round(rand_range(-10, 10))
	$Sprite.z_index = z
	$Sprite2.z_index = z
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(velocity)
	if(_cur_opacity < max_opacity):
		_cur_opacity += 1
		$Sprite.modulate.a8 = _cur_opacity
		$Sprite2.modulate.a8 = _cur_opacity
	pass

func _on_Area2D_area_entered(area):
	$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
