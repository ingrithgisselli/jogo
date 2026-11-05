extends CharacterBody2D

signal derrotado

@export var velocidade_horizontal := 70.0 # um pouco menor que a do jogador (90)
@export var velocidade_vertical := 40.0 # lenta, para o jogador conseguir ficar acima dele
@export var altura_acima_do_jogador := 10.0
@export var forca_quique := 250.0
@export var intervalo_dano := 1.0

var jogador: CharacterBody2D
var ja_foi_derrotado := false
var tempo_ate_dano := 0.0
var tempo := 0.0

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var cabeca: Area2D = $Cabeca
@onready var corpo_dano: Area2D = $Dano


func _ready() -> void:
	if GameState.inimigo_derrotado(self):
		queue_free()
		return

	add_to_group("Drone")

	jogador = get_tree().get_first_node_in_group("Jogador") as CharacterBody2D

	if jogador == null:
		push_error("Drone: não encontrei o nó do grupo 'Jogador' na cena!")

	cabeca.body_entered.connect(_on_cabeca_body_entered)
	corpo_dano.body_entered.connect(_on_dano_body_entered)

	if animacao.sprite_frames.has_animation("Movimentação"):
		animacao.play("Movimentação")


func _physics_process(delta: float) -> void:
	if ja_foi_derrotado:
		return

	tempo += delta

	if tempo_ate_dano > 0.0:
		tempo_ate_dano -= delta

	if not is_instance_valid(jogador):
		velocity = Vector2.ZERO
		return

	# Persegue o jogador, pairando com um leve balanço
	var balanco := sin(tempo * 4.0) * 3.0
	var alvo := jogador.global_position + Vector2(0.0, -altura_acima_do_jogador + balanco)
	var diferenca := alvo - global_position

	velocity.x = clampf(diferenca.x * 4.0, -velocidade_horizontal, velocidade_horizontal)
	velocity.y = clampf(diferenca.y * 4.0, -velocidade_vertical, velocidade_vertical)

	if absf(diferenca.x) > 4.0:
		animacao.flip_h = diferenca.x < 0.0 # inverta se o seu sprite olhar para a esquerda

	move_and_slide()

	# Dano contínuo enquanto o jogador continuar encostado
	if corpo_dano.overlaps_body(jogador):
		_tentar_causar_dano()


# Pisão: jogador parado ou caindo, e acima do drone
func _jogador_esta_por_cima() -> bool:
	return jogador.velocity.y >= 0.0 and jogador.global_position.y < global_position.y


func _on_dano_body_entered(body: Node2D) -> void:
	if body == jogador:
		_tentar_causar_dano()


func _tentar_causar_dano() -> void:
	if ja_foi_derrotado or tempo_ate_dano > 0.0:
		return

	# Jogador por cima do drone: não leva dano (é o pisão)
	if _jogador_esta_por_cima():
		return

	jogador.receber_dano()
	tempo_ate_dano = intervalo_dano


func _on_cabeca_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != jogador:
		return

	if _jogador_esta_por_cima():
		jogador.velocity.y = -forca_quique # quique para cima
		_derrotar()
	else:
		_tentar_causar_dano() # bateu de baixo para cima


func _derrotar() -> void:
	ja_foi_derrotado = true
	GameState.registrar_derrota(self)
	derrotado.emit()

	velocity = Vector2.ZERO

	cabeca.set_deferred("monitoring", false)
	corpo_dano.set_deferred("monitoring", false)

	queue_free()
