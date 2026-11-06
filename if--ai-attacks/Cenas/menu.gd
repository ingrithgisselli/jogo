extends Control

@onready var botao_iniciar: TextureButton = $CenterContainer/VBoxContainer/Iniciar
@onready var botao_sair: TextureButton = $CenterContainer/VBoxContainer/Sair
@onready var botao_tutorial: TextureButton = $CenterContainer/VBoxContainer/Tutorial

func _ready() -> void:
	botao_iniciar.pressed.connect(_on_iniciar_pressed)
	botao_sair.pressed.connect(_on_sair_pressed)
	botao_tutorial.pressed.connect(_on_tutorial_pressed)
	
	for b in [botao_iniciar, botao_sair, botao_tutorial]:
		b.mouse_entered.connect(func(): b.modulate = Color(1.2, 1.2, 1.2))
		b.mouse_exited.connect(func(): b.modulate = Color.WHITE)

	botao_iniciar.grab_focus() 

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Fase 1.tscn")
func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Tutorial.tscn")
func _on_sair_pressed() -> void:
	get_tree().quit()
