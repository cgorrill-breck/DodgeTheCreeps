"""
gravity scale = 0
collision mask should not be checked
Mob exists on layer 1 and does not look on any layers for collisions
the Player will look to layer 1 by haing its Mask set to 1.
Set the animation scale to .75 just like with player set to .5	
"""
extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
signal mob_hit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob_types = animated_sprite_2d.sprite_frames.get_animation_names()
	animated_sprite_2d.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	print(body.get_instance_id())
	mob_hit.emit()
	print("hit")
	queue_free()
