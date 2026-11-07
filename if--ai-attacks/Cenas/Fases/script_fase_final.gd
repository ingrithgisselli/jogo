extends Node2D

signal fim

const TOTAL_COLETAVEIS := 3

var coletaveis_restantes := TOTAL_COLETAVEIS
var chefao_derrotado := false
var finalizacao := false

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
	_verificar_finalizacao()


func _on_vilao_derrotado() -> void:
	chefao_derrotado = true
	print("Chefão derrotado!")
	_verificar_finalizacao()


func _verificar_finalizacao() -> void:
	if finalizacao:
		return

	if coletaveis_restantes == 0 and chefao_derrotado:
		finalizacao = true
		fim.emit()
		iniciar_finalizacao()


func iniciar_finalizacao() -> void:
	print("Você ganhou")
