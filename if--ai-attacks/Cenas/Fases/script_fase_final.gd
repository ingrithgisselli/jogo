extends Node2D

signal cutscene_desbloqueada

const TOTAL_COLETAVEIS := 3

var coletaveis_restantes := TOTAL_COLETAVEIS
var chefao_derrotado := false
var cutscene_ja_desbloqueada := false

@onready var jogador: CharacterBody2D = %Jogador
@onready var vilao = %Chefão


func _ready() -> void:
	print("Fase final iniciada!")
	print("Coletáveis restantes: ", coletaveis_restantes)

	if vilao.has_signal("derrotado"):
		vilao.derrotado.connect(_on_vilao_derrotado)


func coletavel_apanhado() -> void:
	coletaveis_restantes = max(coletaveis_restantes - 1, 0)
	print("Coletáveis restantes: ", coletaveis_restantes)

	if coletaveis_restantes == 0:
		print("Todos os coletáveis foram apanhados!")

	_verificar_cutscene()


func _on_vilao_derrotado() -> void:
	chefao_derrotado = true
	print("Chefão derrotado!")
	_verificar_cutscene()


func _verificar_cutscene() -> void:
	if cutscene_ja_desbloqueada:
		return

	if coletaveis_restantes == 0 and chefao_derrotado:
		cutscene_ja_desbloqueada = true
		print("Objetivos concluídos! A cutscene pode começar.")
		cutscene_desbloqueada.emit()
		iniciar_cutscene()


func iniciar_cutscene() -> void:
	print("A lógica da cutscene será adicionada aqui.")
