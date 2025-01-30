extends RigidBody2D
@export var projectile_lifespan := 2.0

func _ready():
	# Destroy the projectile after 5 seconds to avoid clutter
	await get_tree().create_timer(projectile_lifespan).timeout
	queue_free()
