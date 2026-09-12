extends Node2D

var missile_scene: PackedScene = preload("res://scenes/missile.tscn")
var meteor_scene: PackedScene = preload("res://scenes/meteor.tscn")
@onready var player = $Player
@onready var spawn_positions = $Positions
@onready var timer_meteor = $TimerMeteor
@onready var score_label = $Score
@onready var life_container = $LifeContainer
@onready var game_over = $GameOver

var score: int = 0:
	set(new_value):
		score = new_value
		if score_label:
			score_label.text = "Score: " + str(score)		
	
var is_game_over: bool = false

func _on_player_missile_shoot(missile_position: Vector2) -> void:
	if is_game_over == true:
		return
	var missile_instance = missile_scene.instantiate()
	missile_instance.global_position = missile_position
	add_child(missile_instance)
	
func _on_timer_meteor_timeout() -> void:
	if is_game_over == true:
		return
	var meteor_positions_list = spawn_positions.get_children()
	var meteor_spawn_position = meteor_positions_list.pick_random()
	var meteor_instance = meteor_scene.instantiate()
	meteor_instance.global_position = meteor_spawn_position.global_position
	meteor_instance.destroyed.connect(_on_meteor_destroyed)
	add_child(meteor_instance)

func _on_meteor_destroyed() -> void:
	score += 10
	timer_meteor.wait_time *= 0.99
	
	# Define um teto para o timer
	if timer_meteor.wait_time <= 0.40:
		timer_meteor.wait_time = 0.40

func _on_player_life_changed(current_life: int) -> void:
	var lifes: Array[Node] = life_container.get_children()
	for i in range(lifes.size()):
		if i < current_life:
			lifes[i].visible = true
		else:
			lifes[i].visible = false

func _on_player_player_died() -> void:
	is_game_over = true
	gameover()

func gameover() -> void:
	timer_meteor.stop()
	game_over.visible = true
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
