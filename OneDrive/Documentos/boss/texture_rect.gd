extends CharacterBody2D

# Configurações do movimento e pulo
@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -400.0

# Configurações de Vida
signal health_changed(new_health)

@export var max_health: int = 3
var current_health: int

# Pega a gravidade padrão configurada nas configurações do projeto Godot
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	current_health = max_health
	# Emite o sinal ao iniciar para carregar a vida cheia na tela
	emit_signal("health_changed", current_health)

func _physics_process(delta: float):
	# 1. Aplica a Gravidade se o personagem estiver no ar
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Lógica do Pulo (Usa a tecla Espaço ou Cima por padrão)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Movimentação para Esquerda e Direita (Seta Direita / Seta Esquerda ou A / D)
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Aplica os movimentos
	move_and_slide()

# --- SISTEMA DE DANO E VIDA ---

func take_damage(amount: int = 1):
	if current_health <= 0:
		return
		
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	# Avisa o TextureRect para trocar de imagem
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("O jogador morreu!")
	# Recarrega a fase quando as vidas terminarem
	get_tree().reload_current_scene()
