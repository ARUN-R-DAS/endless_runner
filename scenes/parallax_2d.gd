extends Parallax2D

@export var scroll_speed = Vector2(500, 0)

func _process(delta):
	scroll_offset -= scroll_speed * delta
	if global.is_game_over:
		scroll_speed = Vector2.ZERO
