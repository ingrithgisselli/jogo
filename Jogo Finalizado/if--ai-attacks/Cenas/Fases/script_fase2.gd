extends Node2D  

@onready var area_proxima_fase := $FimdeFase  
@onready var jogador := %Jogador
@onready var animação: AnimatedSprite2D = %Portão
@onready var computador: AnimatedSprite2D = %Computador
@onready var liberado
func _ready() -> void:
	liberado = GameState.algum_quiz_correto("fase2")
	area_proxima_fase.visible = liberado
	area_proxima_fase.monitoring = liberado
	
	if GameState.posicao_salva:
		jogador.global_position = GameState.posicao_jogador
		animação.play("Aberto")
		computador.play("Desligado")
		return
