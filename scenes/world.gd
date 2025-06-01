extends Node2D

@onready var button: Button = $Button


var segments = [
	preload("res://segments/1.tscn"),
	preload("res://segments/2.tscn"),
	preload("res://segments/3.tscn"),
	preload("res://segments/4.tscn")
]

var speed = 200
var first_seg = true
var inst

func _ready() -> void:
	randomize()
	spawn_inst(0,0)
	spawn_inst(398,0)

func _physics_process(delta: float) -> void:
	chunk_loading(delta)
	game_over()
	restart_game()

#functions-----------------------------------------
func chunk_loading(delta):
	for segment in $segments.get_children():
		segment.position.x -= speed*delta
		if segment.position.x < -398*1.5:
			spawn_inst(segment.position.x + 398*2,0)
			segment.queue_free()
#------------------------------------------------------------------------------------------------------
func spawn_inst(x,y):
	if first_seg:
		inst = segments[0].instantiate()
		first_seg = false
	else:
		inst = segments[randi() % segments.size()].instantiate()
	inst.position = Vector2(x,y)
	$segments.add_child(inst)
#------------------------------------------------------------------------------------------------------
func game_over():
	if global.is_game_over:
		print("gameover from world")
		global.is_game_over = false
		speed = 0
		button.disabled = false
		button.visible = true
#------------------------------------------------------------------------------------------------
func restart_game():
	if button.button_pressed:
		print("button_pressed")
		get_tree().reload_current_scene()
