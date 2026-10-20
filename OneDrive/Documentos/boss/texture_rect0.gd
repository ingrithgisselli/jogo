extends TextureRect

# Lista de imagens de vidas (do menor para o maior)
# Exemplo: Elemento 0 = 0 vidas, Elemento 3 = 3 vidas
@export var imagens_de_vida: Array[Texture2D]

func _ready():
	# Procura o jogador 'nois' diretamente na cena de forma automática
	var player = get_node_or_null("../../../nois") # Ajuste o número de '../' se precisar subir na árvore
	if player:
		player.health_changed.connect(_on_health_changed)
		
func _on_health_changed(nova_vida: int):
	# Garante que o índice não vai estourar a quantidade de imagens cadastradas
	var indice = clamp(nova_vida, 0, imagens_de_vida.size() - 1)
	
	if imagens_de_vida.size() > 0:
		texture = imagens_de_vida[indice]
