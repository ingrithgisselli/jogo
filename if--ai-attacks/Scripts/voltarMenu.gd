extends Control

@onready var voltar_menu: Button = $"VBoxContainer/Voltar Menu"


func _ready() -> void:
	voltar_menu.pressed.connect(_on_voltar_pressed)
	
	for b in [voltar_menu]:
		b.mouse_entered.connect(func(): b.modulate = Color(1.2, 1.2, 1.2))
		b.mouse_exited.connect(func(): b.modulate = Color.WHITE)

	voltar_menu.grab_focus() 

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Menu.tscn")
