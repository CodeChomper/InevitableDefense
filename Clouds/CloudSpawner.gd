extends Node2D
var timePassed = 0

export (bool) var right

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePassed += delta
	if timePassed > 0.2 and get_child_count() < 10:
		var c1 = load("res://Clouds/Cloud01.tscn")
		var c2 = load("res://Clouds/Cloud02.tscn")
		var c3 = load("res://Clouds/Cloud03.tscn")
		var c4 = load("res://Clouds/Cloud04.tscn")
		var cloud
		var c = round(rand_range(1,4))
		if c == 1:
			cloud = c1.instance()
		elif c == 2:
			cloud = c2.instance()
		elif c == 3:
			cloud = c3.instance()
		else:
			cloud = c4.instance()
			
		add_child(cloud)
		cloud.position.y += rand_range(-200, 200)
		if !right:
			cloud.velocity.x = cloud.velocity.x * -1
			cloud.position.x = rand_range(50, -3000)
		else:
			cloud.position.x = rand_range(50, 3000)
		timePassed = 0
	pass
