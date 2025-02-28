extends Node
var vida: int#0
var defensa: int#1
var fuerza: int#2
var destreza: int#3
var inteligencia: int#4
var agilidad: int#5
var resistencia: int#6
var carisma: int#7
var suerte: int#8
var arcano: int#9
var mente: int#10
var fe: int#11
var moneadas:int#12
var resistencia_fisica: int#13
var resistencia_magica: int#14
var resistencia_luz: int#15
var resistencia_fuego: int#16
var resistencia_veneno: int#17
var resistencia_oscuridad: int#18
enum ConjuntoDeStads {
	vida, defensa, fuerza, destreza, inteligencia, agilidad,
	 resistencia, carisma, suerte, arcano, mente, fe, monedas, resistencia_fisica
}

	# [100, 30, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5,5]  ejemplo de como debe ser el array 
	
func obtener_stat(stats, stat_index):
	return stats[stat_index] if stat_index < stats.size() else 0

func modificar_stat(stats, stat_index, valor):
	if stat_index < stats.size():
		stats[stat_index] += valor
