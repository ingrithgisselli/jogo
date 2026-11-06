extends CharacterBody2D

signal derrotado
signal vida_alterada(nova_vida)

const SPEED := 70.0
const VIDA_MAXIMA := 5
const FORCA_MOLA := 300.0
const INTERVALO_DANO := 1.0
const INVULNERABILIDADE := 0.8
const EVITAR_DANO := 0.4        # evita dano logo depois de ser pisado
const TEMPO_PARALISIA := 0.8   # tempo parado depois de tomar dano

@export var nome_animacao_andar := "Máquina"      # nome no seu SpriteFrames
@export var nome_animacao_derrota := "Danificado"

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var vida := VIDA_MAXIMA
var jogador: CharacterBody2D
var ja_foi_derrotado := false
var tempo_ate_dano := 0.0
var tempo_invulneravel := 0.0
var tempo_paralisado := 0.0
var precisa_sair_de_cima := false

@onready var animacao := get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
@onready var cabeca := get_node_or_null("Cabeca") as Area2D
@onready var corpo_dano := get_node_or_null("Dano") as Area2D
@onready var colisao := get_node_or_null("CollisionShape2D") as CollisionShape2D


func _ready() -> void:
	add_to_group("Chefao")
	jogador = get_tree().get_first_node_in_group("Jogador") as CharacterBody2D

	if jogador == null:
		push_error("Chefão: não encontrei o nó do grupo 'Jogador' na cena!")

	if cabeca:
		cabeca.body_entered.connect(_on_cabeca_body_entered)
	if corpo_dano:
		corpo_dano.body_entered.connect(_on_dano_body_entered)

	_voltar_a_andar()

	call_deferred("emit_signal", "vida_alterada", vida)


func _physics_process(delta: float) -> void:
	if ja_foi_derrotado:
		velocity = Vector2.ZERO
		return

	if tempo_ate_dano > 0.0:
		tempo_ate_dano -= delta
	if tempo_paralisado > 0.0:
		tempo_paralisado -= delta
	if tempo_invulneravel > 0.0:
		tempo_invulneravel -= delta
		# Acabou a invulnerabilidade: termina a animação de dano
		if tempo_invulneravel <= 0.0:
			_voltar_a_andar()

	if precisa_sair_de_cima and is_instance_valid(jogador):
		if jogador.is_on_floor() and not _jogador_esta_sobre_o_chefao():
			precisa_sair_de_cima = false

	if corpo_dano and is_instance_valid(jogador) and corpo_dano.overlaps_body(jogador):
		_tentar_causar_dano()

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	if tempo_paralisado > 0.0:
		# Paralisado depois de tomar dano
		velocity.x = 0.0
	elif is_instance_valid(jogador):
		var diferenca_x := jogador.global_position.x - global_position.x
		if absf(diferenca_x) > 2.0:
			velocity.x = signf(diferenca_x) * SPEED
			if animacao:
				animacao.flip_h = diferenca_x > 0.0
		else:
			velocity.x = 0.0
	else:
		velocity.x = 0.0

	move_and_slide()


func _jogador_esta_sobre_o_chefao() -> bool:
	for i in jogador.get_slide_collision_count():
		var colisao_jogador := jogador.get_slide_collision(i)
		if colisao_jogador.get_collider() == self and colisao_jogador.get_normal().y < -0.7:
			return true
	return false


func _on_dano_body_entered(body: Node2D) -> void:
	if body == jogador:
		_tentar_causar_dano()


func _tentar_causar_dano() -> void:
	if ja_foi_derrotado or tempo_ate_dano > 0.0 or not is_instance_valid(jogador):
		return

	if jogador.global_position.y < global_position.y or jogador.velocity.y > 0.0:
		return

	jogador.receber_dano()
	tempo_ate_dano = INTERVALO_DANO


func _on_cabeca_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != jogador:
		return

	if jogador.velocity.y > 0.0:
		if not precisa_sair_de_cima:
			receber_dano(1)
			precisa_sair_de_cima = true
		jogador.velocity.y = -FORCA_MOLA
		tempo_ate_dano = EVITAR_DANO
	elif tempo_ate_dano <= 0.0:
		jogador.receber_dano()
		tempo_ate_dano = INTERVALO_DANO


func receber_dano(valor: int = 1) -> void:
	if ja_foi_derrotado or tempo_invulneravel > 0.0:
		return

	vida = max(vida - valor, 0)
	tempo_invulneravel = INVULNERABILIDADE

	vida_alterada.emit(vida)

	if vida == 0:
		_derrotar()
	else:
		tempo_paralisado = TEMPO_PARALISIA
		_tocar_danificado()


# Toca "Danificado" ajustando a velocidade para durar exatamente a invulnerabilidade
func _tocar_danificado() -> void:
	if animacao == null or not animacao.sprite_frames.has_animation(nome_animacao_derrota):
		return

	var frames := animacao.sprite_frames
	var fps := frames.get_animation_speed(nome_animacao_derrota)
	var quantidade := frames.get_frame_count(nome_animacao_derrota)
	var duracao := float(quantidade) / fps if fps > 0.0 else INVULNERABILIDADE

	animacao.speed_scale = duracao / INVULNERABILIDADE
	animacao.play(nome_animacao_derrota)


func _voltar_a_andar() -> void:
	if animacao and animacao.sprite_frames.has_animation(nome_animacao_andar):
		animacao.speed_scale = 1.0
		animacao.play(nome_animacao_andar)


func _derrotar() -> void:
	ja_foi_derrotado = true
	velocity = Vector2.ZERO
	derrotado.emit()

	if cabeca:
		cabeca.set_deferred("monitoring", false)
	if corpo_dano:
		corpo_dano.set_deferred("monitoring", false)
	if colisao:
		colisao.set_deferred("disabled", true)

	if animacao and animacao.sprite_frames.has_animation(nome_animacao_derrota):
		_tocar_danificado()
		await get_tree().create_timer(INVULNERABILIDADE).timeout
		animacao.visible = false
	queue_free()
