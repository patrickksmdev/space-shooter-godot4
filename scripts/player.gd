extends CharacterBody2D

signal life_changed(current_life: int)
signal player_died
signal missile_shoot(missile_position: Vector2)
@export var speed: int = 300
@export var life: int = 3
@export var fire_rate: float = 0.75
@onready var position_missile = $Position

var can_shoot: bool = true

func _physics_process(delta): 
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	if Input.is_action_pressed("Atirar"):
		shoot()

	move_and_slide()
	
func shoot() -> void:
	if not can_shoot:
		return
	can_shoot = false
	missile_shoot.emit(position_missile.global_position)
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func take_damage(amount: int):
	life -= amount
	life_changed.emit(life)
	if life <= 0:
		die()

func die():
	player_died.emit()
	queue_free()
