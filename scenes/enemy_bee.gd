extends CharacterBody2D

var speed = 20
var player_position
var player = global.player
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

#orbitting
var orbit_radius = 20
var stop_distance = orbit_radius - 10.0
var orbit_speed = 2.0
var target_angle = 0.0
var attack_position = Vector2.ZERO



func _physics_process(delta):
	if is_instance_valid(player):
		player_position = player.global_position
	else:
		player_position = Vector2.ZERO
	var direction = global_position.direction_to(player_position)
	#print(direction)
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	move_and_slide()
	flip(velocity)
	get_distance_and_orbit(delta)
#---------------------------------
func flip(velocity):
	if velocity.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
#-------------------------------
func get_distance_and_orbit(delta):
	if is_instance_valid(global.player):
		var player_pos = player.global_position
		var to_player = global_position.direction_to(player_pos)
		var distance = global_position.distance_to(player_pos)
		
		target_angle = randf() * TAU  # Random angle on the circle
		var angle_step = orbit_speed * delta
		target_angle += angle_step

		# Calculate new orbit position
		attack_position = player_pos + Vector2(cos(target_angle), sin(target_angle)) * orbit_radius
		var dir_to_target = global_position.direction_to(attack_position)
		
		if global_position.distance_to(attack_position) > 15:
			velocity = dir_to_target * speed
			anim.play("default")
		else:
			velocity = Vector2.ZERO
			anim.play("attack")

#---------------------------------
