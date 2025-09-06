extends CharacterBody2D

@onready var area: Area2D = $Area2D

func _ready() -> void:
	print('boar spawned in world')
	pass

func _physics_process(delta: float) -> void:
	gravity()
	controls()
	delete_when_off_screen()
	move_and_slide()

#functions---------------------------------
func gravity():
	if not is_on_floor():
		velocity.y += 30
#------------------------------------------------------------------------------------------------------
func controls():
	velocity.x = -20
	pass  
#------------------------------------------------------------------------------------------------------
func delete_when_off_screen():
	#print(global_position.y)
	if global_position.y > 400:
		#global.is_game_over = true
		print("boar removed from world")
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var player = body
	body.velocity.y = -300
	body.velocity.x = -200
	body.hurt()
