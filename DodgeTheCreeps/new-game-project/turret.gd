class_name Turret
extends Node2D

@export var projectile_scene: PackedScene  # Assign the projectile scene in the editor
@export var fire_interval: float = 1     # Time between shots
@export var fire_speed: float = 500        # Speed of the projectile
@export var arc_angle: float = 90           # Arc in degrees for random shots
@export var turret_lifespan := 1.5

@onready var timer = $Timer
@onready var fire_point = $Marker2D
@onready var lifespan_timer: Timer = $Lifespan_Timer

func _ready():
	$AnimatedSprite2D.flip_h = true
	if global_position.x > get_viewport_rect().size.x / 2:
		scale.x = -1
		scale.y = -1
		$AnimatedSprite2D.flip_v = true
		
	timer.wait_time = fire_interval
	timer.timeout.connect(fire_projectile)
	timer.start()
	lifespan_timer.wait_time = turret_lifespan
	lifespan_timer.start()
	

func fire_projectile():
	if projectile_scene:
		var projectile = projectile_scene.instantiate() as RigidBody2D
		get_tree().root.add_child(projectile)
		projectile.global_position = fire_point.global_position

		# Calculate random direction within the arc
		var half_arc = arc_angle / 2.0
		var random_angle = deg_to_rad(randf_range(-half_arc, half_arc))
		var direction = Vector2.RIGHT.rotated(global_rotation + random_angle)
			
		$AnimatedSprite2D.rotation = rotation + random_angle
		$AnimatedSprite2D.play("fire")
		
		# Apply impulse to the projectile
		projectile.apply_impulse(direction * fire_speed)


func _on_lifespan_timer_timeout() -> void:
	queue_free()
