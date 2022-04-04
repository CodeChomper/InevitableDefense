extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var humans_left = 0 setget set_humans_left
var wave = 0 setget set_wave
var enemies_left = 0 setget set_enemies_left
var alien_scene = load("res://Alien/Alien.tscn")
var alien2_scene = load("res://Alien/Alien02.tscn")
var game_over_screen

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
	if humans_left <= 0:
		game_over()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$Mission.play()
	game_over_screen = find_node("GameOverScreen")
	game_over_screen.visible = false
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
	if wave > 1:
		$WaveIncoming.play(0)
	for i in range(wave):
		# start wave 1
		var which_alien = round(rand_range(1,100))
		var alien
		if which_alien > 75:
			alien = alien_scene.instance()
			pass
		else:
			alien = alien2_scene.instance()
			pass
		get_parent().call_deferred("add_child", alien)
		var x_pos = rand_range(10, 2900) #2900
		var y_pos = rand_range(100, 250)
		alien.global_position = Vector2(x_pos, y_pos)
		pass
	pass

func game_over():
	game_over_screen.visible = true
	$GameOver.play(0)
	$GameOverTimer.start(5)


func _on_WaveStartTimer_timeout():
	start_wave()
	pass # Replace with function body.


func _on_GameOverTimer_timeout():
	get_tree().reload_current_scene()
	pass # Replace with function body.
