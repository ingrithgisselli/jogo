extends Area2D

var coletado := false
@export var coleta: AudioStream
func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if coletado or body.name != "Jogador":
		return
	coletado = true
	ConfigAudio.tocar_efeito(coleta)
	var nivel = get_tree().current_scene
	if nivel and nivel.has_method("coletavel_apanhado"):
		nivel.coletavel_apanhado()
	queue_free()
