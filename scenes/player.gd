extends CharacterBody2D

func _ready() -> void:
	pass

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
			velocity.x = -100
		elif Input.is_action_pressed("ui_right"):
			velocity.x = 50
		else:
			velocity.x = 0
#------------------------------------------------------------------------------------------------------
func game_over():
	print(global_position.y)
	if global_position.y > 400:
		global.is_game_over = true
		print("gameover from player")
		queue_free()
	
