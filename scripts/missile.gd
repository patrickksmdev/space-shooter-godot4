extends Area2D
 
@export var speed: float = 600.0
@export var damage: int = 1

func _physics_process(delta: float) -> void:
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(damage)
		$CollisionShape2D.set_deferred("disabled", true)
		queue_free()
