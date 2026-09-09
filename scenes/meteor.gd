extends Area2D

signal destroyed
@export var speed = 100
@export var rotation_speed = 1.3
@export var life = 3

@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	health_bar.value = life

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	$Sprite2D.rotation -= rotation_speed * delta
	if life <= 0:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
		
func take_damage(amount):
	life -= amount
	health_bar.value = life
	if life <= 0:
		queue_free
		destroyed.emit()
