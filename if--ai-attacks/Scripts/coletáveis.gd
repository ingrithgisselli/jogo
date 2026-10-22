extends Area2D

var coletado := false

func _ready() -> void:
	# Garante a conexão do sinal caso não esteja feito no editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if coletado or body.name != "Jogador":
		return

	coletado = true
	
	var nivel = get_tree().current_scene
	if nivel and nivel.has_method("coletavel_apanhado"):
		nivel.coletavel_apanhado()

	queue_free()
