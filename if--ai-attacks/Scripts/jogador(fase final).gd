extends CharacterBody2D

signal vida_alterada(nova_vida)

enum Estado_Jogador{
	parado,
	andando,
	pulando,
	caindo,
	dano
}
@onready var animação: AnimatedSprite2D = $Animação
const SPEED = 120
const JUMP_VELOCITY = -400.0
const delay := 1.0                 
const TEMPO_DANO := 0.35           
const INVULNERABILIDADE := 1.5     
const RECUO_X := 200.0             
const RECUO_Y := -250.0            
@export var vida_maxima: int = 3
var vida_atual: int
var Status: Estado_Jogador
var tempo_dano := 0.0
var tempo_invulneravel := 0.0
@export var som_pulo: AudioStream
@export var som_dano: AudioStream
func _ready() -> void:
	add_to_group("Jogador")
	vida_atual = vida_maxima
	
	call_deferred("emit_signal", "vida_alterada", vida_atual)
	preparar_Estado_parado()

func _physics_process(delta: float) -> void:
	if tempo_invulneravel > 0.0:
		tempo_invulneravel -= delta
	atualizar_piscada()

	if not is_on_floor():
		velocity += (get_gravity() * delta)

	match Status:
		Estado_Jogador.parado:
			Estado_parado()
		Estado_Jogador.andando:
			Estado_andando()
		Estado_Jogador.pulando:
			Estado_pulando()
		Estado_Jogador.caindo:
			Estado_caindo()
		Estado_Jogador.dano:
			Estado_dano(delta)

	move_and_slide()

func preparar_Estado_parado():
	Status = Estado_Jogador.parado
	animação.play("parado")

func preparar_Estado_andando():
	Status = Estado_Jogador.andando
	animação.play("Andar")

func preparar_Estado_pulando():
	Status = Estado_Jogador.pulando
	animação.play("Pulando")
	velocity.y=JUMP_VELOCITY
	ConfigAudio.tocar_efeito(som_pulo)
func preparar_Estado_caindo():
	Status = Estado_Jogador.caindo
	animação.play("Caindo")

func preparar_Estado_dano():
	Status = Estado_Jogador.dano
	tempo_dano = TEMPO_DANO
	animação.play("Dano")
	
	var sentido := 1.0 if animação.flip_h else -1.0
	velocity = Vector2(sentido * RECUO_X, RECUO_Y)

func Estado_parado():
	movimentacao()
	if not is_on_floor():
		preparar_Estado_caindo()
		return
	if velocity.x !=0:
		preparar_Estado_andando()
		return
	if Input.is_action_just_pressed("Pular"):
		preparar_Estado_pulando()
		return

func Estado_andando():
	movimentacao()
	if not is_on_floor():
		preparar_Estado_caindo()
		return
	if velocity.x ==0:
		preparar_Estado_parado()
		return
	if Input.is_action_just_pressed("Pular"):
		preparar_Estado_pulando()
		return

func Estado_pulando():
	movimentacao()
	if velocity.y > 0:
		preparar_Estado_caindo()
		return
	if is_on_floor():
		preparar_Estado_parado()
		return

func Estado_caindo():
	movimentacao()
	
	if velocity.y < 0.0:
		Status = Estado_Jogador.pulando
		animação.play("Pulando")
		return
	if is_on_floor():
		if velocity.x == 0:
			preparar_Estado_parado()
		else:
			preparar_Estado_andando()
		return

func Estado_dano(delta: float):
	
	velocity.x = move_toward(velocity.x, 0.0, RECUO_X * 4.0 * delta)
	tempo_dano -= delta
	if tempo_dano <= 0.0:
		if is_on_floor():
			preparar_Estado_parado()
		else:
			preparar_Estado_caindo()

func movimentacao():
	var direction := Input.get_axis("Esquerda", "Direita")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction<0:
		animação.flip_h=true
	elif direction>0:
		animação.flip_h=false

func atualizar_piscada() -> void:
	if tempo_invulneravel > 0.0 and vida_atual > 0:
		animação.modulate.a = 0.4 if int(tempo_invulneravel * 12.0) % 2 == 0 else 1.0
	else:
		animação.modulate.a = 1.0


func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0 or tempo_invulneravel > 0.0:
		return

	vida_atual = clamp(vida_atual - quantidade, 0, vida_maxima)
	vida_alterada.emit(vida_atual)
	ConfigAudio.tocar_efeito(som_dano)
	if vida_atual <= 0:
		morrer()
		return

	tempo_invulneravel = INVULNERABILIDADE
	preparar_Estado_dano()

func morrer() -> void:
	set_physics_process(false)
	animação.modulate.a = 1.0
	animação.play("Dano")
	await get_tree().create_timer(delay).timeout
	animação.visible=false
	print("O jogador morreu!")
	await get_tree().create_timer(delay).timeout
	get_tree().reload_current_scene()
