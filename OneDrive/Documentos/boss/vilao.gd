extends CharacterBody2D

signal derrotado

const SPEED := 350.0
const VIDA_MAXIMA := 5
const FORCA_MOLA := 600.0
const INTERVALO_DANO := 1.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var vida := VIDA_MAXIMA
var player: CharacterBody2D
var ja_foi_derrotado := false
var tempo_ate_dano := 0.0


func _ready() -> void:
	# Procura o jogador pelo nome exato em toda a cena principal
	player = get_tree().current_scene.find_child("nois", true, false) as CharacterBody2D

	if player == null:
		push_error("Vilão: não encontrei o jogador 'nois' na cena!")

	# Conecta os sinais de forma segura
	if has_node("Cabeca"):
		$Cabeca.body_entered.connect(_on_cabeca_body_entered)
	if has_node("Dano"):
		$Dano.body_entered.connect(_on_dano_body_entered)


func _physics_process(delta: float) -> void:
	if ja_foi_derrotado:
		velocity.x = 0.0
		return

	if tempo_ate_dano > 0.0:
		tempo_ate_dano -= delta

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Persegue o jogador horizontalmente (corrigido para ir diretamente em direção a ele)
	if is_instance_valid(player):
		if abs(player.global_position.x - global_position.x) > 2.0:
			velocity.x = sign(player.global_position.x - global_position.x) * SPEED
		else:
			velocity.x = 0.0
	else:
		velocity.x = 0.0

	move_and_slide()


# Dano lateral do corpo
func _on_dano_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != player:
		return
	if tempo_ate_dano > 0.0:
		return

	# Se o jogador estiver acima do vilão ou a cair, ignora o dano lateral (para permitir saltar na cabeça)
	if player.global_position.y < global_position.y or player.velocity.y > 0.0:
		return

	if get_tree().current_scene.has_method("perder_vida"):
		get_tree().current_scene.perder_vida()
		tempo_ate_dano = INTERVALO_DANO


# Acerto na cabeça (Prioridade máxima)
func _on_cabeca_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != player:
		return

	# Se o jogador estiver a cair (velocidade Y positiva)
	if player.velocity.y > 0.0:
		receber_dano(1)
		player.velocity.y = -FORCA_MOLA  # Impulso de mola para cima
	else:
		# Se bater de baixo para cima contra a cabeça
		if get_tree().current_scene.has_method("perder_vida"):
			get_tree().current_scene.perder_vida()


func receber_dano(valor: int = 1) -> void:
	if ja_foi_derrotado:
		return

	vida = max(vida - valor, 0)
	print("Vidas do chefão: ", vida)

	if vida == 0:
		ja_foi_derrotado = true
		derrotado.emit()
		queue_free()
