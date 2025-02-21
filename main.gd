extends Node2D

@onready var hud = $Jugador/Camera2D2/HUD
@onready var audio_player = $AudioStreamPlayer2D
@onready var BarradeVida_label = hud.get_node("VBoxContainer/Vida")
@onready var Puntaje_label = hud.get_node("VBoxContainer/Puntos")

func _ready() -> void:
	
	audio_player.play()
	actualizar_vida(500)  

func actualizar_vida(vida):
	BarradeVida_label.text = "Vida: " + str(vida)
	#Aun no hay optencion de puntos aun por que al matar al primer enemigo ganas y tal... y por que no tube tiempo... pero hay daño al enemigo :D
