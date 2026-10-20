extends CharacterBody2D
signal health_changed(new_health)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@export var max_health: int = 3
var current_health: int

func _ready():
	current_health = max_health
	# 2. Emite o sinal ao iniciar o jogo
	emit_signal("health_changed", current_health)

func take_damage(amount: int = 1):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	# 3. Emite o sinal sempre que tomar dano
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("O jogador morreu!")
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
