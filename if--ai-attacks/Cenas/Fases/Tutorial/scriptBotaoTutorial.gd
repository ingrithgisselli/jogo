extends Area2D
@onready var botao := %Button
@export var offset := Vector2(0, 0)
@export var quiz_tutorial = "res://Cenas/Fases/Tutorial/Quiz Tutorial.tscn"

func _ready() -> void:
	await get_tree().process_frame
	botao.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	botao.pressed.connect(_on_interagir)
	
func atualizar_posicao_botao() -> void:
	var transform := get_viewport().canvas_transform
	var posicao_tela := transform*(global_position+offset)
	botao.global_position = posicao_tela-botao.size/2
	
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
	_tutorial()
	
func _tutorial() -> void:
	call_deferred("carregar_tutorial")
	
		
func carregar_tutorial():
	get_tree().change_scene_to_file(quiz_tutorial)
	
func _on_button_pressed() -> void:
	pass # Replace with function body.
