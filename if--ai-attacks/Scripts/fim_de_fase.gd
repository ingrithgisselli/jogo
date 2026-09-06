extends Area2D

@export var proxima_fase = "" 

func _on_body_entered(_body: Node2D) -> void:
	call_deferred("carregar_proxima_cena")
	
func carregar_proxima_cena():
	get_tree().change_scene_to_file("res://Cenas/Fases/" + proxima_fase + ".tscn")
