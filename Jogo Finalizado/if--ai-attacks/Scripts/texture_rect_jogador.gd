extends TextureRect
@export var imagens_de_vida: Array[Texture2D]

func _ready() -> void:
	
	var jogador = get_tree().current_scene.find_child("Jogador", true, false)
	if jogador == null:
		push_warning("Interface de vida: não encontrei o nó 'Jogador' na cena!")
		return
	jogador.vida_alterada.connect(_on_vida_alterada)

func _on_vida_alterada(nova_vida: int) -> void:
	if imagens_de_vida.is_empty():
		return

	
	var indice = clamp(nova_vida, 0, imagens_de_vida.size() - 1)
	texture = imagens_de_vida[indice]
