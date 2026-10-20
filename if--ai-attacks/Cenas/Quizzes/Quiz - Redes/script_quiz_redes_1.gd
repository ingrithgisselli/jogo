extends Control

@onready var botao_a := $VBoxContainer/BotãoA
@onready var botao_b := $VBoxContainer/BotãoB
@onready var botao_c := $VBoxContainer/BotãoC
@onready var botao_d := $VBoxContainer/BotãoD

@export var resposta_certa: String = "A"

func _ready() -> void:
	botao_a.pressed.connect(_on_resposta_selecionada.bind("A"))
	botao_b.pressed.connect(_on_resposta_selecionada.bind("B"))
	botao_c.pressed.connect(_on_resposta_selecionada.bind("C"))
	botao_d.pressed.connect(_on_resposta_selecionada.bind("D"))

func _on_resposta_selecionada(opcao: String) -> void:
	if opcao == resposta_certa:
		print("Resposta certa!")
		GameState.marcar_correto("fase3", "redes1")  
		get_tree().change_scene_to_file("res://Cenas/Fases/Fase 3.tscn")  
	else:
		print("Resposta errada!")
