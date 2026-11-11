extends Node

var quizzes := {
	"fase1": {"hardware1": false, "hardware2": false, "hardware3": false},
	"fase2": {"software1": false, "software2": false, "software3": false},
	"fase3": {"redes1": false, "redes2": false, "redes3": false},
	"fase4": {"ti_verde1": false, "ti_verde2": false, "ti_verde3": false},
}

var posicao_jogador := Vector2.ZERO
var posicao_salva := false

func marcar_correto(fase: String, quiz: String) -> void:
	quizzes[fase][quiz] = true

func algum_quiz_correto(fase: String) -> bool:
	return quizzes[fase].values().has(true)
