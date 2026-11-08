extends Control

@onready var botao_iniciar: TextureButton = $CenterContainer/VBoxContainer/Iniciar

@onready var botao_tutorial: TextureButton = $CenterContainer/VBoxContainer/Tutorial
@onready var botao_som = $CenterContainer/VBoxContainer/Som
@onready var painel_som = $PanelContainer
	
func _ready() -> void:
	botao_iniciar.pressed.connect(_on_iniciar_pressed)
	
	botao_tutorial.pressed.connect(_on_tutorial_pressed)
	botao_som.pressed.connect(painel_som.abrir)
	for b in [botao_iniciar, botao_tutorial, botao_som]:
		b.mouse_entered.connect(func(): b.modulate = Color(1.2, 1.2, 1.2))
		b.mouse_exited.connect(func(): b.modulate = Color.WHITE)

	botao_iniciar.grab_focus() 

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Fase 1.tscn")
func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Tutorial/Tutorial.tscn")
