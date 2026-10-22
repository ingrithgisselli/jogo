extends Control

const acerto := Color("#7CFF8A")
const erro := Color("#FF6B6B")
const delay := 1.0

@onready var botoes := {
	"A": $VBoxContainer/BotãoA,
	"B": $VBoxContainer/BotãoB,
	"C": $VBoxContainer/BotãoC,
	"D": $VBoxContainer/BotãoD,
}

@export var resposta_certa: String = "D"
@export var fase_id: String = "fase3"
@export var quiz_id: String = "redes3"
@export_file("*.tscn") var proxima_cena: String = "res://Cenas/Fases/Fase 3.tscn"

var travado := false

func _ready() -> void:
	for letra in botoes:
		botoes[letra].pressed.connect(_on_resposta_selecionada.bind(letra))

func _on_resposta_selecionada(opcao: String) -> void:
	if travado:
		return

	var botao: Button = botoes[opcao]

	if opcao == resposta_certa:
		travado = true
		_piscar(botao, acerto)
		GameState.marcar_correto(fase_id, quiz_id)
		await get_tree().create_timer(delay).timeout
		get_tree().change_scene_to_file(proxima_cena)
	else:
		_piscar(botao, erro)

func _piscar(botao: Button, cor: Color) -> void:
	for nome in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		botao.add_theme_color_override(nome, cor)
