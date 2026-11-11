extends Node

@export var musica: AudioStream


func _ready() -> void:
	MusicaFundo.tocar(musica)
