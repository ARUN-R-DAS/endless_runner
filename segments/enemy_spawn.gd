extends Node2D

@onready var marker: Marker2D = $Marker2D
var inst

var enemies = [
	preload("res://scenes/enemy_boar.tscn"),
	preload("res://scenes/enemy_snail.tscn")
] 

func _ready() -> void:
	spawn_inst(marker.position)
#------------------------------------------------------------------------------------------------------
func spawn_inst(pos):
	inst = enemies[randi() % enemies.size()].instantiate()
	inst.position = Vector2(pos)
	$".".add_child(inst)
