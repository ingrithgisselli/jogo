extends CharacterBody2D

signal vida_alterada(nova_vida)

enum Estado_Jogador{
	parado,
	andando,
	pulando,
	caindo
}
@onready var animação: AnimatedSprite2D = $Animação
const SPEED = 90.0
const JUMP_VELOCITY = -300.0
@export var vida_maxima: int = 3
var vida_atual: int
var Status: Estado_Jogador

func _ready() -> void:
	vida_atual = vida_maxima
	# Adiado para a interface já estar conectada ao sinal quando ele for emitido
	call_deferred("emit_signal", "vida_alterada", vida_atual)
	preparar_Estado_parado()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += (get_gravity() * delta)*0.85
		
	match Status:
		Estado_Jogador.parado:
			Estado_parado()
		Estado_Jogador.andando:
			Estado_andando()
		Estado_Jogador.pulando:
			Estado_pulando()
		Estado_Jogador.caindo:
			Estado_caindo()
	
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

func preparar_Estado_caindo():
	Status = Estado_Jogador.caindo
	animação.play("Caindo")
	
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
	if is_on_floor():
		if velocity.x == 0:
			preparar_Estado_parado()
		else:
			preparar_Estado_andando()
		return

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

#Sistema de vida
func receber_dano(quantidade: int = 1) -> void:
	if vida_atual <= 0:
		return

	vida_atual = clamp(vida_atual - quantidade, 0, vida_maxima)
	
	vida_alterada.emit(vida_atual)

	if vida_atual <= 0:
		morrer()

func morrer() -> void:
	print("O jogador morreu!")
	get_tree().reload_current_scene()
