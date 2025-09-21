extends CharacterBody2D

const IS_PLAYER = true

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var health: int
signal player_hurt
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
#---- variable jump height ---
var is_jumping = false
var jump_time = 0
var max_hold_time = .3
var jump_speed = 120
#var gravity = 900
#--- sound effects ----
const JUMP = preload("res://music/jump.wav")
const LASER_SHOOT = preload("res://music/laserShoot.wav")

func _ready() -> void:
	global.player = self
	health = 3
	global.is_game_over = false

func _physics_process(delta: float) -> void:
	gravity()
	controls(delta)
	game_over()
	move_and_slide()

#functions---------------------------------
func gravity():
	if not is_on_floor():
		velocity.y += 10
#------------------------------------------------------------------------------------------------------
func controls(delta):
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			is_jumping = true
			audio_stream_player.stream = JUMP
			audio_stream_player.play()
			jump_time = 0
			velocity.y = -jump_speed
	if is_jumping:
		if Input.is_action_pressed("ui_accept") and jump_time < max_hold_time:
			jump_time += delta
			velocity.y = -jump_speed
		else:
			is_jumping = false
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
	audio_stream_player.stream = preload("res://music/laserShoot.wav")
	audio_stream_player.play()
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
#------------------------------------------------------------------------------------------

	
