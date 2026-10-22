extends CharacterBody2D

signal derrotado
signal vida_alterada(nova_vida)

const SPEED := 200.0
const VIDA_MAXIMA := 5
const FORCA_MOLA := 600.0
const INTERVALO_DANO := 1.0
const INVULNERABILIDADE := 1.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var vida := VIDA_MAXIMA
var jogador: CharacterBody2D
var ja_foi_derrotado := false
var tempo_ate_dano := 0.0
var tempo_invulneravel := 0.0


func _ready() -> void:
	add_to_group("Chefao")
	jogador = get_tree().get_first_node_in_group("Jogador") as CharacterBody2D

	if jogador == null:
		push_error("Vilão: não encontrei o nó 'Jogador' na cena!")

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
	if tempo_invulneravel > 0.0:
		tempo_invulneravel -= delta

	# Se o jogador continuar encostado no corpo, o dano se repete a cada INTERVALO_DANO
	if has_node("Dano") and is_instance_valid(jogador) and $Dano.overlaps_body(jogador):
		_tentar_causar_dano()

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Persegue o jogador horizontalmente
	if is_instance_valid(jogador):
		if abs(jogador.global_position.x - global_position.x) > 2.0:
			velocity.x = sign(jogador.global_position.x - global_position.x) * SPEED
		else:
			velocity.x = 0.0
	else:
		velocity.x = 0.0

	move_and_slide()


# Dano lateral do corpo
func _on_dano_body_entered(body: Node2D) -> void:
	if body == jogador:
		_tentar_causar_dano()


func _tentar_causar_dano() -> void:
	if ja_foi_derrotado or tempo_ate_dano > 0.0:
		return

	# Se o jogador estiver acima do vilão ou caindo, ignora o dano lateral (para permitir pular na cabeça)
	if jogador.global_position.y < global_position.y or jogador.velocity.y > 0.0:
		return

	jogador.receber_dano()
	tempo_ate_dano = INTERVALO_DANO


# Acerto na cabeça (prioridade máxima)
func _on_cabeca_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != jogador:
		return

	# Se o jogador estiver caindo (velocidade Y positiva)
	if jogador.velocity.y > 0.0:
		receber_dano(1)
		jogador.velocity.y = -FORCA_MOLA  # Impulso de mola para cima
	elif tempo_ate_dano <= 0.0:
		# Se bater de baixo para cima contra a cabeça
		jogador.receber_dano()
		tempo_ate_dano = INTERVALO_DANO


func receber_dano(valor: int = 1) -> void:
	if ja_foi_derrotado or tempo_invulneravel > 0.0:
		return

	vida = max(vida - valor, 0)
	tempo_invulneravel = INVULNERABILIDADE
	print("Vidas do chefão: ", vida)

	# Avisa a interface para atualizar a imagem da vida
	vida_alterada.emit(vida)

	if vida == 0:
		ja_foi_derrotado = true
		derrotado.emit()
		queue_free()
