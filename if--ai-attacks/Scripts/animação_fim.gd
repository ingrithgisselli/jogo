extends AnimatedSprite2D

@export var intervalo_virada := 1           # segundos entre cada virada do sprite
@export var AnimacaoFim := "Animação Fim"     # vazio = usa a animação que está selecionada no sprite


func _ready() -> void:
	var nome := AnimacaoFim if AnimacaoFim != "" else String(animation)

	if sprite_frames and sprite_frames.has_animation(nome):
		play(nome)
	else:
		push_error("CenaFinal: não encontrei a animação '" + nome + "'")

	# Timer criado por código: vira o sprite a cada intervalo, para sempre
	var timer := Timer.new()
	timer.wait_time = intervalo_virada
	timer.autostart = true
	timer.timeout.connect(_virar)
	add_child(timer)


func _virar() -> void:
	flip_h = not flip_h
