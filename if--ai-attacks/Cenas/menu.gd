extends Control

@onready var botao_jogar = $CenterContainer/VBoxContainer/Iniciar


func _ready():
	botao_jogar.pressed.connect(_on_jogar_pressed)
	
	botao_jogar.grab_focus() 
	botao_jogar.button_down.connect(func(): $BotaoJogar/Label.position.y += 2)
	botao_jogar.button_up.connect(func(): $BotaoJogar/Label.position.y -= 2)

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Cenas/Fases/Fase 1.tscn")

func _on_opcoes_pressed():
	get_tree().change_scene_to_file("res://cenas/opcoes.tscn")

func _on_sair_pressed():
	get_tree().quit()
