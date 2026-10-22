extends TextureRect

# Lista de imagens de vidas (do menor para o maior)
# Exemplo: Elemento 0 = 0 vidas, Elemento 3 = 3 vidas
@export var imagens_de_vida: Array[Texture2D]

func _ready() -> void:
	# Procura o jogador pelo nome em toda a cena principal
	var jogador = get_tree().current_scene.find_child("Jogador", true, false)
	if jogador == null:
		push_warning("Interface de vida: não encontrei o nó 'Jogador' na cena!")
		return
	jogador.vida_alterada.connect(_on_vida_alterada)

func _on_vida_alterada(nova_vida: int) -> void:
	if imagens_de_vida.is_empty():
		return

	# Garante que o índice não vai estourar a quantidade de imagens cadastradas
	var indice = clamp(nova_vida, 0, imagens_de_vida.size() - 1)
	texture = imagens_de_vida[indice]
