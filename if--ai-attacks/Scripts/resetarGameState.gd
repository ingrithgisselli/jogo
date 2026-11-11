extends Button

@export_file("*.tscn") var cena_menu := "res://Cenas/Menu.tscn"   # ajuste para o caminho do seu menu

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	GameState.resetar()
	get_tree().change_scene_to_file(cena_menu)
