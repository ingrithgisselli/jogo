extends Node2D

signal cutscene_desbloqueada

const TOTAL_COLETAVEIS := 3

var coletaveis_restantes := TOTAL_COLETAVEIS
var vidas := 3
var chefao_derrotado := false
var cutscene_ja_desbloqueada := false

@onready var nois: CharacterBody2D = $nois
@onready var vilao = $vilao


func _ready() -> void:
	print("Fase final iniciada! Vidas: ", vidas)
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


func perder_vida() -> void:
	vidas -= 1
	print("Ai! Vidas restantes: ", vidas)

	if vidas <= 0:
		print("Game Over! Reiniciando a fase...")
		get_tree().reload_current_scene()


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


func _on_cabeca_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
