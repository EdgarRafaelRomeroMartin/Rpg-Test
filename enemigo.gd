extends CharacterBody2D

@export var speed: float = 50.0  
@export var fireball_scene: PackedScene = preload("res://bola_de_fuego.tscn")
@export var distancia_optima: float = 100.0  
@export var margen: float = 10.0  
@export var tiempo_fallo_disparo: float = 1.5  
@export var vida: int = 100  

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D  

var jugador: Node2D  
var direccion_actual = Vector2.ZERO  
var ultima_direccion_disparo = Vector2.RIGHT 
var fallos_consecutivos = 0  
var max_fallos = 2  

func _ready():
	jugador = get_tree().get_nodes_in_group("Jugador")[0] if get_tree().has_group("Jugador") else null
	lanzar_bola_de_fuego()

func _physics_process(_delta):
	if jugador:
		ajustar_distancia_al_jugador()

func ajustar_distancia_al_jugador():
	var direccion_hacia_jugador = (jugador.global_position - global_position).normalized()
	var distancia_al_jugador = jugador.global_position.distance_to(global_position)
	var nueva_direccion = Vector2.ZERO
	
	
	if abs(direccion_hacia_jugador.x) > abs(direccion_hacia_jugador.y):
	
		if distancia_al_jugador < distancia_optima - margen:
			nueva_direccion = Vector2.RIGHT if direccion_hacia_jugador.x < 0 else Vector2.LEFT  
		elif distancia_al_jugador > distancia_optima + margen:
			nueva_direccion = Vector2.LEFT if direccion_hacia_jugador.x < 0 else Vector2.RIGHT 
	else:
	
		if distancia_al_jugador < distancia_optima - margen:
			nueva_direccion = Vector2.DOWN if direccion_hacia_jugador.y < 0 else Vector2.UP  
		elif distancia_al_jugador > distancia_optima + margen:
			nueva_direccion = Vector2.UP if direccion_hacia_jugador.y < 0 else Vector2.DOWN 
	
	
	if fallos_consecutivos >= max_fallos:
		nueva_direccion = ajustar_posicion_para_atinar()
		fallos_consecutivos = 0  
	
	
	if nueva_direccion != Vector2.ZERO:
		direccion_actual = nueva_direccion
	
	velocity = direccion_actual * speed
	move_and_slide()
	actualizar_animacion()

func actualizar_animacion():
	if direccion_actual == Vector2.RIGHT:
		sprite.scale.x = -1  
		animation_player.play("Enemigo_Izquierda")
	elif direccion_actual == Vector2.LEFT:
		sprite.scale.x = 1  
		animation_player.play("Enemigo_Izquierda") 
	elif direccion_actual == Vector2.UP:
		animation_player.play("Enemigo_Arriba")
	elif direccion_actual == Vector2.DOWN:
		animation_player.play("Enemigo_Abajo")

func lanzar_bola_de_fuego():
	while jugador:
		await get_tree().create_timer(2.0).timeout  
		
		var direccion_disparo = obtener_direccion_hacia_jugador()
		ultima_direccion_disparo = direccion_disparo  
		var bola = fireball_scene.instantiate()
		bola.global_position = global_position
		bola.set_direccion(direccion_disparo)
		get_parent().add_child(bola)

		await get_tree().create_timer(tiempo_fallo_disparo).timeout
		if bola and is_instance_valid(bola):
			fallos_consecutivos += 1
		else:
			fallos_consecutivos = 0  
func obtener_direccion_hacia_jugador() -> Vector2:
	var direccion_hacia_jugador = (jugador.global_position - global_position).normalized()
	
	if abs(direccion_hacia_jugador.x) > abs(direccion_hacia_jugador.y):
		return Vector2.RIGHT if direccion_hacia_jugador.x > 0 else Vector2.LEFT
	else:
		return Vector2.DOWN if direccion_hacia_jugador.y > 0 else Vector2.UP

func ajustar_posicion_para_atinar() -> Vector2:
	if ultima_direccion_disparo == Vector2.RIGHT or ultima_direccion_disparo == Vector2.LEFT:
		return Vector2.UP if randi() % 2 == 0 else Vector2.DOWN
	else:
		return Vector2.LEFT if randi() % 2 == 0 else Vector2.RIGHT

func take_damage(amount: int):
	vida -= amount
	if vida <= 0:
		get_tree().change_scene_to_file("res://creditos.tscn")
	#	queue_free()  
