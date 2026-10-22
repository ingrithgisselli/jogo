extends TextureRect

# Lista de imagens de vidas (do menor para o maior)
# Exemplo: Elemento 0 = 0 vidas, Elemento 5 = 5 vidas
@export var imagens_baterias: Array[Texture2D]

func _ready() -> void:
	# Procura o vilão pelo nome em toda a cena principal
	var vilao = get_tree().current_scene.find_child("Chefão", true, false)
	if vilao == null:
		push_warning("Interface de vida: não encontrei o nó 'Chefão' na cena!")
		return
	vilao.vida_alterada.connect(_on_vida_alterada)
	# Mostra a vida atual já na largada
	_on_vida_alterada(vilao.vida)

func _on_vida_alterada(nova_vida: int) -> void:
	if imagens_baterias.is_empty():
		return

	# Garante que o índice não vai estourar a quantidade de imagens cadastradas
	var indice = clamp(nova_vida, 0, imagens_baterias.size() - 1)
	texture = imagens_baterias[indice]
