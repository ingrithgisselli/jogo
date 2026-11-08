extends PanelContainer
signal fechado
@onready var slider_musica: HSlider = %HSliderMúsica
@onready var slider_efeitos: HSlider = %HSliderEfeitos
@onready var botao_voltar: Button = %Voltar
@onready var som_musica := get_node_or_null("%Música") as AudioStreamPlayer2D
@onready var som_efeitos := get_node_or_null("%Efeitos") as AudioStreamPlayer2D

func _ready() -> void:
	hide()

	slider_musica.value = ConfigAudio.obter_volume("Música")
	slider_efeitos.value = ConfigAudio.obter_volume("Efeitos")

	slider_musica.value_changed.connect(func(v): ConfigAudio.definir_volume("Música", v))
	slider_efeitos.value_changed.connect(func(v): ConfigAudio.definir_volume("Efeitos", v))
	slider_musica.drag_ended.connect(_on_musica_solto)
	slider_efeitos.drag_ended.connect(_on_efeitos_solto)

	botao_voltar.pressed.connect(fechar)


func abrir() -> void:
	show()
	slider_musica.grab_focus()


func fechar() -> void:
	ConfigAudio.salvar()
	hide()
	fechado.emit()

# Prévia da música: só toca se ela ainda não estiver tocando
func _on_musica_solto(_mudou: bool) -> void:
	if som_musica and not som_musica.playing:
		som_musica.play()


# Prévia dos efeitos: toca o som de teste
func _on_efeitos_solto(_mudou: bool) -> void:
	if som_efeitos:
		som_efeitos.play()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		fechar()
		get_viewport().set_input_as_handled()
