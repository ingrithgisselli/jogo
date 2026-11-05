extends Node
const QUIZZES_INICIAIS := {
"fase1": {"hardware1": false, "hardware2": false, "hardware3": false},
"fase2": {"software1": false, "software2": false, "software3": false},
"fase3": {"redes1": false, "redes2": false, "redes3": false},
"fase4": {"ti_verde1": false, "ti_verde2": false, "ti_verde3": false},
}
var quizzes := QUIZZES_INICIAIS.duplicate(true)
var posicao_jogador := Vector2.ZERO
var posicao_salva := false
var vida_jogador := -1 
var inimigos_derrotados := {} 
var _derrotados_na_fase := {} 

func marcar_correto(fase: String, quiz: String) -> void:
	quizzes[fase][quiz] = true
	
func algum_quiz_correto(fase: String) -> bool:
	return quizzes[fase].values().has(true)

func salvar_antes_do_quiz(jogador: CharacterBody2D) -> void:
	posicao_jogador = jogador.global_position
	posicao_salva = true
	vida_jogador = jogador.vida_atual
	inimigos_derrotados = _derrotados_na_fase.duplicate()

func iniciar_fase() -> void:
	_derrotados_na_fase = inimigos_derrotados.duplicate()
	
func registrar_derrota(inimigo: Node) -> void:
	_derrotados_na_fase[_chave_inimigo(inimigo)] = true
	
func inimigo_derrotado(inimigo: Node) -> bool:
	return inimigos_derrotados.has(_chave_inimigo(inimigo))
	
func _chave_inimigo(inimigo: Node) -> String:
	var raiz: Node = inimigo.owner
	if raiz == null:
		raiz = get_tree().current_scene
	return str(raiz.scene_file_path, ":", raiz.get_path_to(inimigo))

func resetar() -> void:
	quizzes = QUIZZES_INICIAIS.duplicate(true)
	posicao_jogador = Vector2.ZERO
	posicao_salva = false
	vida_jogador = -1
	inimigos_derrotados.clear()
	_derrotados_na_fase.clear()
