extends TextureRect


@export var imagens_baterias: Array[Texture2D]

func _ready() -> void:
	
	var vilao = get_tree().current_scene.find_child("Chefão", true, false)
	if vilao == null:
		push_warning("Interface de vida: não encontrei o nó 'Chefão' na cena!")
		return
	vilao.vida_alterada.connect(_on_vida_alterada)
	
	_on_vida_alterada(vilao.vida)

func _on_vida_alterada(nova_vida: int) -> void:
	if imagens_baterias.is_empty():
		return

	
	var indice = clamp(nova_vida, 0, imagens_baterias.size() - 1)
	texture = imagens_baterias[indice]
