extends CharacterBody2D
signal health_changed(new_health)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@export var max_health: int = 3
var current_health: int

func _ready():
	current_health = max_health
	# 2. Emite o sinal ao iniciar o jogo
	emit_signal("health_changed", current_health)

func take_damage(amount: int = 1):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	
	# 3. Emite o sinal sempre que tomar dano
	emit_signal("health_changed", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("O jogador morreu!")
	get_tree().reload_current_scene()
