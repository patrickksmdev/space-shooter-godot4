extends Area2D

signal destroyed
@export var speed: float = 100.0
@export var rotation_speed: float = 1.3
@export var life: int = 3

const METEOR_TEXTURES: Array[Texture2D] = [
	preload("res://assets/Sprites/Meteors/spaceMeteors_001.png"),
	preload("res://assets/Sprites/Meteors/spaceMeteors_002.png"),
	preload("res://assets/Sprites/Meteors/spaceMeteors_003.png"),
	preload("res://assets/Sprites/Meteors/spaceMeteors_004.png"),
]

@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	$Sprite2D.texture = METEOR_TEXTURES.pick_random()
	health_bar.max_value = life
	health_bar.value = life

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	$Sprite2D.rotation -= rotation_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if life <= 0:
		return
	if body.has_method("take_damage"):
		body.take_damage(1)
		$CollisionShape2D.set_deferred("disabled", true)
		queue_free()
		
func take_damage(amount: int) -> void:
	if life <= 0:
		return
	life -= amount
	health_bar.value = life
	if life <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		destroyed.emit()
		queue_free()
