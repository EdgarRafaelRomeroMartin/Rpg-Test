extends CharacterBody2D

@export var speed: float = 100.0  
var ataque_escena: PackedScene = preload("res://hacha_de_acero.tscn")
var vida: int = 5
@onready var animation_player = $AnimationPlayer  
@onready var sprite = $Sprite2D  

var ultima_direccion = Vector2.RIGHT  
func _process(_delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("Arriba"):
		direction.y -= 1
		animation_player.play("Animacion_Arriba")
	elif Input.is_action_pressed("Abajo"):
		direction.y += 1
		animation_player.play("Animacion_Abajo")
	elif Input.is_action_pressed("Izq"):
		direction.x -= 1
		sprite.scale.x = 1  
		animation_player.play("Animacion_Izquierda")
	elif Input.is_action_pressed("Der"):
		direction.x += 1
		sprite.scale.x = -1 
		animation_player.play("Animacion_Izquierda")  
	
	if direction != Vector2.ZERO:
		ultima_direccion = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_just_pressed("ClicIzq"):
		realizar_ataque()

func realizar_ataque():
	var ataque = ataque_escena.instantiate()

	var posicion_ataque = global_position + (ultima_direccion * 20)

	get_parent().add_child(ataque)

	ataque.configurar_ataque(posicion_ataque, ultima_direccion)

	
	if ataque.has_method("reproducir_animacion"):
		ataque.reproducir_animacion()

func take_damage(amount: int):
	vida -= amount
	get_parent().actualizar_vida(vida)
	if vida <= 0:
		get_tree().change_scene_to_file("res://menu_de_inicio.tscn") 
