extends CharacterBody2D

signal derrotado

@export var velocidade := 40.0
@export var forca_quique := 250.0
@export var intervalo_dano := 1.0
@export var pausa_ao_virar := 0.6      # segundos parado antes de virar
@export var margem_borda := 1.0        # px do sensor para dentro da ponta do corpo
@export var nome_animacao := "Movimentação2"   

const TEMPO_ENTRE_VIRADAS := 0.3

var direcao := 1                       
var jogador: CharacterBody2D
var ja_foi_derrotado := false
var tempo_ate_dano := 0.0
var tempo_para_virar := 0.0
var tempo_parado := 0.0

@onready var animacao: AnimatedSprite2D = $AnimatedSprite2D
@onready var detector_chao: RayCast2D = $DetectorChao
@onready var cabeca: Area2D = $Cabeca
@onready var corpo_dano: Area2D = $Dano
@onready var colisao: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	add_to_group("Inimigo")
	jogador = get_tree().get_first_node_in_group("Jogador") as CharacterBody2D
	if jogador == null:
		push_error("Inimigo: não encontrei o nó do grupo 'Jogador' na cena!")

	cabeca.body_entered.connect(_on_cabeca_body_entered)
	corpo_dano.body_entered.connect(_on_dano_body_entered)

	if animacao.sprite_frames.has_animation("Movimentação2"):
		animacao.play("Movimentação2")
	_atualizar_lado()


func _physics_process(delta: float) -> void:
	if ja_foi_derrotado:
		return

	if tempo_ate_dano > 0.0:
		tempo_ate_dano -= delta
	if tempo_para_virar > 0.0:
		tempo_para_virar -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if tempo_parado > 0.0:
		
		tempo_parado -= delta
		velocity.x = 0.0
		if tempo_parado <= 0.0:
			_virar()
			animacao.play(nome_animacao)
	else:
		velocity.x = direcao * velocidade

	move_and_slide()


	if is_on_floor() and tempo_parado <= 0.0 and tempo_para_virar <= 0.0:
		if is_on_wall() or not detector_chao.is_colliding():
			tempo_parado = pausa_ao_virar
			animacao.pause()   

	
	if is_instance_valid(jogador) and corpo_dano.overlaps_body(jogador):
		_tentar_causar_dano()


func _virar() -> void:
	direcao *= -1
	tempo_para_virar = TEMPO_ENTRE_VIRADAS
	_atualizar_lado()


func _atualizar_lado() -> void:
	animacao.flip_h = direcao < 0                 
	_posicionar_detector()
	detector_chao.force_raycast_update()



func _posicionar_detector() -> void:
	var forma := colisao.shape
	var meia_largura := 8.0
	if forma is RectangleShape2D:
		meia_largura = forma.size.x / 2.0
	elif forma is CapsuleShape2D or forma is CircleShape2D:
		meia_largura = forma.radius

	detector_chao.position.x = colisao.position.x + (meia_largura - margem_borda) * direcao


func _on_dano_body_entered(body: Node2D) -> void:
	if body == jogador:
		_tentar_causar_dano()


func _tentar_causar_dano() -> void:
	if ja_foi_derrotado or tempo_ate_dano > 0.0:
		return
	
	if jogador.velocity.y > 0.0 and jogador.global_position.y < global_position.y:
		return

	jogador.receber_dano()
	tempo_ate_dano = intervalo_dano


func _on_cabeca_body_entered(body: Node2D) -> void:
	if ja_foi_derrotado or body != jogador:
		return

	if jogador.velocity.y > 0.0:
		jogador.velocity.y = -forca_quique   
		_derrotar()
	else:
		_tentar_causar_dano()               


func _derrotar() -> void:
	ja_foi_derrotado = true
	derrotado.emit()
	velocity = Vector2.ZERO
	tempo_parado = 0.0
	cabeca.set_deferred("monitoring", false)
	corpo_dano.set_deferred("monitoring", false)
	colisao.set_deferred("disabled", true)

	if animacao.sprite_frames.has_animation("destruido"):
		animacao.play("destruido")
		await animacao.animation_finished
	queue_free()
