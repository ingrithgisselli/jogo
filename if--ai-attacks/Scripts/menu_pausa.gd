extends CanvasLayer

@export_file("*.tscn") var cena_menu := "res://Cenas/Fases/Menu.tscn"   # ajuste para o seu menu

@onready var caixa: PanelContainer = %Caixa
@onready var botao_retomar: Button = %Retomar
@onready var botao_som: Button = %BotaoSom
@onready var botao_menu: Button = %VoltarMenu
@onready var painel_som = %PainelSom


func _ready() -> void:
	# Precisa continuar funcionando enquanto o jogo está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	botao_retomar.pressed.connect(retomar)
	botao_som.pressed.connect(_abrir_som)
	botao_menu.pressed.connect(voltar_ao_menu)
	painel_som.fechado.connect(_on_som_fechado)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("Pausa"):
		return

	if visible:
		# Com o painel de som aberto, o Esc fecha só o painel
		if not painel_som.visible:
			retomar()
	else:
		pausar()
	get_viewport().set_input_as_handled()


func pausar() -> void:
	get_tree().paused = true
	caixa.show()
	painel_som.hide()
	show()
	botao_retomar.grab_focus()


func retomar() -> void:
	get_tree().paused = false
	hide()


func _abrir_som() -> void:
	caixa.hide()
	painel_som.abrir()


func _on_som_fechado() -> void:
	caixa.show()
	botao_som.grab_focus()


func voltar_ao_menu() -> void:
	get_tree().paused = false          # sem isso o menu principal abriria pausado
	GameState.resetar()                # perde todo o progresso
	get_tree().change_scene_to_file(cena_menu)
