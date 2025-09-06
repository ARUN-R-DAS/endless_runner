extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var health = 4
signal player_hurt

func _ready() -> void:
	global.player = self

func _physics_process(delta: float) -> void:
	gravity()
	controls()
	game_over()
	move_and_slide()

#functions---------------------------------
func gravity():
	if not is_on_floor():
		velocity.y += 10
#------------------------------------------------------------------------------------------------------
func controls():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y -= 200
	if Input.is_action_pressed("ui_left"):
		velocity.x = -80
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 50
	else:
			velocity.x = 0
#------------------------------------------------------------------------------------------------------
func game_over():
	#print(global_position.y)
	if global_position.y > 400:
		global.is_game_over = true
		print("gameover from player")

#------------------------------------------------------------------------------------------
func hurt():
	health -= 1
	anim.play("hurt")
	emit_signal("player_hurt",health)
	await get_tree().create_timer(0.5).timeout
	anim.play("walk")
	
	if health <=0:
		die()
#---------------------------------------------------------------------------------------
func die():
	if global.is_game_over:
		return
	global.is_game_over = true
	print("player died")
	
	var dummy_scene = preload("res://scenes/DummyPlayer.tscn")
	var dummy = dummy_scene.instantiate()
	get_parent().add_child(dummy)
	dummy.global_position = global_position
	queue_free()
