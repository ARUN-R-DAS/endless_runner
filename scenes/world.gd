extends Node2D

@onready var button: Button = $Button


var segments = [
	preload("res://segments/1.tscn"),
	preload("res://segments/2.tscn"),
	preload("res://segments/3.tscn"),
	preload("res://segments/4.tscn"),
	preload("res://segments/5.tscn")
]

var speed = 100
var first_seg = true
var second_seg = false
var inst
# --- HEALTH Visual
const heart_scene = preload("res://scenes/life_heart.tscn")
@onready var hearts_container: HBoxContainer = $CanvasLayer/HBoxContainer
# --- dummy spawn on death
@onready var player: CharacterBody2D = $player
# --- Score
var score: int
@onready var label: Label = $CanvasLayer/Label


func _ready() -> void:
	randomize()
	spawn_inst(0,0)
	spawn_inst(398,0)
	var player = get_node("/root/world/player")
	player.connect("player_hurt",Callable(self,"_on_player_hurt"))
	update_hearts(player.health)
	score = 0

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
		second_seg = true
	elif second_seg:
		inst = segments[-1].instantiate()
		second_seg = false
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
#-------------------------------------------------------------------------------------------
func _on_player_hurt(current_health: int):
	update_hearts(current_health)
#----------------------------------------------------------------------------------------------
func update_hearts(health: int):
	var current = hearts_container.get_child_count()

	# If losing lives
	if health < current:
		for i in range(current - 1, health - 1, -1):
			var heart = hearts_container.get_child(i)
			blink_and_remove(heart)

	# If gaining lives
	elif health > current:
		for i in range(current, health):
			var heart = heart_scene.instantiate()
			hearts_container.add_child(heart)
#--------------------------------------------------------------------------------------
func blink_and_remove(heart: Node):
	var tween = create_tween()
	tween.tween_property(heart, "modulate:a", 0.0, 0.2) # fade out
	tween.tween_property(heart, "modulate:a", 1.0, 0.2) # fade in
	tween.tween_property(heart, "modulate:a", 0.0, 0.2) # fade out again
	tween.tween_callback(Callable(heart, "queue_free"))
#---------------------------------------------------------------------------------------
func _on_score_timer_timeout() -> void:
	if is_instance_valid(player):
		score += 1
		label.text = "Score:" + str(score)
	else:
		label.text = "You scored:" + str(score)
