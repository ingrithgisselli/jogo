extends Area2D

@onready var botao := %Button
@export var offset := Vector2(0, 0)
@export var cena_quizTIverde1 = "res://Cenas/Quizzes/Quiz - TI Verde/Quiz_TIVerde1.tscn"
@export var cena_quizTIverde2 = "res://Cenas/Quizzes/Quiz - TI Verde/Quiz_TIVerde2.tscn"
@export var cena_quizTIverde3 = "res://Cenas/Quizzes/Quiz - TI Verde/Quiz_TIVerde3.tscn"
 
func _ready() -> void:
	await get_tree().process_frame
	botao.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	botao.pressed.connect(_on_interagir)
			
func atualizar_posicao_botao() -> void:
	var transform := get_viewport().canvas_transform
	var posicao_tela := transform * (global_position + offset)
	botao.global_position = posicao_tela - botao.size / 2

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		botao.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		botao.visible = false

func _process(_delta: float) -> void:
	if botao.visible:
		atualizar_posicao_botao()
		if Input.is_action_just_pressed("Acessar"):
			_on_interagir()
			

func _on_interagir() -> void:
	var jogadores := get_tree().get_nodes_in_group("Jogador")
	if jogadores.size()>0:
		GameState.posicao_jogador = jogadores[0].global_position
		GameState.posicao_salva = true
	_sorteio()

func _sorteio() -> void:
	var aleatorio:=randi_range(1,3)
	if aleatorio==1:
		call_deferred("carregar_quizTIverde1")
	elif aleatorio==2:
		call_deferred("carregar_quizTIverde2")
	elif aleatorio==3:
		call_deferred("carregar_quizTIverde3")
			
func carregar_quizTIverde1():
	get_tree().change_scene_to_file(cena_quizTIverde1)

func carregar_quizTIverde2():
	get_tree().change_scene_to_file(cena_quizTIverde2)
	
func carregar_quizTIverde3():
	get_tree().change_scene_to_file(cena_quizTIverde3)
	


func _on_button_pressed() -> void:
	pass # Replace with function body.
