extends CharacterBody2D

# Sinal para atualizar as vidas na interface
signal health_changed(new_health)

# Configurações de Movimento e Pulo
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = 400.0

# Configurações de Vida
@export var max_health: int = 3
var current_health: int

# Pega a gravidade configurada no projeto do Godot
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_health = max_health
	# Emite o sinal ao iniciar para carregar os corações/baterias cheios
	emit_signal("health_changed", current_health)

func _physics_process(delta: float):
	# 1. Aplica a gravidade se o personagem estiver no ar
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Lógica do Pulo (Pressionar a tecla Espaço ou Seta para Cima)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Movimentação para a Esquerda e Direita (Setas do teclado ou A/D)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Executa o movimento no jogo
	move_and_slide()

# --- Sistema de Dano ---
func take_damage(amount: int = 1):
	if current_health <= 0:
		return
		
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	# Avisa a interface para trocar a imagem da vida
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("O jogador morreu!")
	get_tree().reload_current_scene()
