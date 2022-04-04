extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var humans_left = 0 setget set_humans_left
var wave = 0 setget set_wave
var enemies_left = 0 setget set_enemies_left
var alien_scene = load("res://Alien/Alien.tscn")

func set_enemies_left(val):
	enemies_left = val;
	$CanvasLayer/EnemyCount.text = str(enemies_left)

func set_wave(val):
	wave = val
	$WaveStartTimer.start(5)
	$CanvasLayer/WaveCount.text = str(wave)

func set_humans_left(val):
	# Update UI
	humans_left = val
	$CanvasLayer/HumanCount.text = str(val)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	set_wave(1)
	pass # Replace with function body.


func on_alien_died():
	set_enemies_left(enemies_left - 1)
	if enemies_left <= 0:
		set_wave(wave + 1)
	
	pass

func on_person_died():
	set_humans_left(humans_left - 1)

func start_wave():
	for i in range(wave):
		# start wave 1
		var alien = alien_scene.instance()
		get_parent().call_deferred("add_child", alien)
		var x_pos = rand_range(200, 2500)
		var y_pos = rand_range(100, 250)
		alien.global_position = Vector2(x_pos, y_pos)
		pass
	pass


func _on_WaveStartTimer_timeout():
	start_wave()
	pass # Replace with function body.
