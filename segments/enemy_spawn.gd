extends Node2D

@onready var spawn_markers: Node = $spawn_markers
var inst

var enemies = [
	preload("res://scenes/enemy_boar.tscn"),
	preload("res://scenes/enemy_snail.tscn")
] 

func _ready() -> void:
	for marker in spawn_markers.get_children():
		spawn_inst(marker.position)
#------------------------------------------------------------------------------------------------------
func spawn_inst(pos):
	inst = enemies[randi() % enemies.size()].instantiate()
	inst.position = Vector2(pos)
	$".".add_child(inst)
