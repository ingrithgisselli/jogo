extends Node

const ARQUIVO := "user://configuracoes.cfg"
const BARRAMENTOS := ["Música", "Efeitos"]

var volumes := {"Música": 0.8, "Efeitos": 0.8}


func _ready() -> void:
	carregar()
	for barramento in BARRAMENTOS:
		_aplicar(barramento)


func obter_volume(barramento: String) -> float:
	return volumes.get(barramento, 1.0)


func definir_volume(barramento: String, valor: float) -> void:
	volumes[barramento] = clampf(valor, 0.0, 100)
	_aplicar(barramento)


func _aplicar(barramento: String) -> void:
	var indice := AudioServer.get_bus_index(barramento)
	if indice == -1:
		push_error("ConfigAudio: não encontrei o barramento '" + barramento + "'")
		return

	var valor: float = volumes[barramento]
	AudioServer.set_bus_mute(indice, valor <= 0.0)
	AudioServer.set_bus_volume_db(indice, linear_to_db(maxf(valor, 0.0001)))


func salvar() -> void:
	var cfg := ConfigFile.new()
	for barramento in BARRAMENTOS:
		cfg.set_value("audio", barramento, volumes[barramento])
	cfg.save(ARQUIVO)


func carregar() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(ARQUIVO) != OK:
		return
	for barramento in BARRAMENTOS:
		volumes[barramento] = cfg.get_value("audio", barramento, volumes[barramento])
		
# Toca um efeito sonoro uma vez, no barramento "Efeitos"
func tocar_efeito(som: AudioStream, volume_db: float = 0.0) -> void:
	if som == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = som
	player.bus = "Efeitos"
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
