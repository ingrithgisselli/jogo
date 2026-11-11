extends CharacterBody2D
enum Estado_Jogador{
	parado,
	andando,
	pulando,
	caindo
}
@onready var animação: AnimatedSprite2D = $Animação
const SPEED = 90.0
const JUMP_VELOCITY = -300.0
var Status: Estado_Jogador

func _ready() -> void:
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
