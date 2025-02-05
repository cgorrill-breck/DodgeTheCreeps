extends Area2D
const BASE_SPEED = 400
const BOOST_SPEED = BASE_SPEED * 2
const COOL_DOWN_SPEED = BASE_SPEED * .75

@export var speed = BASE_SPEED #speed in px/sec
@export var bullet_speed = 400

var screen_size
var in_cooldown := false

signal hit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size 
	hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	handle_boost()
	
	# is_action_pressed is better if you need more granular control over direction and velocity
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func handle_boost():
	if Input.is_action_just_pressed("Boost") and !in_cooldown:
		print("boosted")
		speed = BOOST_SPEED
		$Boost_Timer.start()
		$BoostParticles.emitting = true
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_boost_timer_timeout() -> void:
	print("boost done!")
	speed = COOL_DOWN_SPEED
	in_cooldown = true
	$CooldownTimer.start()
	$BoostParticles.emitting = false
	print("in cooldown")


func _on_cooldown_timer_timeout() -> void:
	in_cooldown = false
	speed = BASE_SPEED
	print("cooldown done")
