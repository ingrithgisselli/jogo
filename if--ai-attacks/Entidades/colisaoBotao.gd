extends Area2D

@onready var botao := %Button
@export var offset := Vector2(0, 0)
@export var cena_quizHard1 = "res://Cenas/Quizzes/Quiz - Hardwares/Quiz_Hardware1.tscn" 
@export var cena_quizHard2 = "res://Cenas/Quizzes/Quiz - Hardwares/Quiz_Hardware2.tscn" 
@export var cena_quizHard3 = "res://Cenas/Quizzes/Quiz - Hardwares/Quiz_Hardware3.tscn"
 
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
	_sorteio()

func _sorteio() -> void:
	var aleatorio_int:=randi_range(1,3)
	if aleatorio_int==1:
		call_deferred("carregar_quizHard1")
	elif aleatorio_int==2:
		call_deferred("carregar_quizHard2")
	elif aleatorio_int==3:
		call_deferred("carregar_quizHard3")
			
func carregar_quizHard1():
	get_tree().change_scene_to_file(cena_quizHard1)

func carregar_quizHard2():
	get_tree().change_scene_to_file(cena_quizHard2)
	
func carregar_quizHard3():
	get_tree().change_scene_to_file(cena_quizHard3)
	
