extends Node

var player := AudioStreamPlayer.new()


func _ready() -> void:
	player.bus = "Música"
	add_child(player)
	player.finished.connect(player.play)   # repete para sempre


# Troca a música; se a mesma já está tocando, não faz nada (não reinicia)
func tocar(musica: AudioStream) -> void:
	if musica == null:
		return
	if player.stream == musica and player.playing:
		return
	player.stream = musica
	player.play()


func parar() -> void:
	player.stop()


# Durante a pausa, deixa a música audível (usado pelo painel de som)
func ouvir_durante_pausa(ouvir: bool) -> void:
	if get_tree().paused:
		player.stream_paused = not ouvir
