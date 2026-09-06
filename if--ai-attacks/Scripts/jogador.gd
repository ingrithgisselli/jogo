extends CharacterBody2D
@onready var animação: AnimatedSprite2D = $Animação



const SPEED = 90.0
const JUMP_VELOCITY = -300.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * delta)*0.85

	# Handle jump.
	if Input.is_action_just_pressed("Pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Esquerda", "Direita")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if is_on_floor():
		if direction>0:
			animação.flip_h=false
			animação.play("Andar")
		elif direction<0:
			animação.flip_h=true
			animação.play("Andar")
		else:
			animação.play("parado")
	elif not is_on_floor():
		if velocity.y<0:
			animação.play("Pulando")
			if direction>0:
				animação.flip_h=false
			elif direction<0:
				animação.flip_h=true
		if velocity.y>0:
			animação.play("Caindo")
			if direction>0:
				animação.flip_h=false
			elif direction<0:
				animação.flip_h=true
	move_and_slide()
