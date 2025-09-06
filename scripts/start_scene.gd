extends Node2D

@onready var start_button = $Button
@onready var run_label = $Label
@onready var bg_rect = $TextureRect  # ColorRect covering screen

func _ready():
	start_button.connect("pressed", Callable(self,"_on_start_pressed"))
	animate_start_button()
	animate_run_label()
	animate_sky()


# --- Start button pulsing/glow effect ---
func animate_start_button():
	start_button.modulate = Color(1, 1, 1, 1)
	var tween = create_tween().set_loops()
	tween.tween_property(start_button, "scale", Vector2(1.1, 1.1), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(start_button, "scale", Vector2(1.0, 1.0), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(start_button, "modulate", Color(1.3, 1.3, 1.3, 1.0), 0.8).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(start_button, "modulate", Color(1, 1, 1, 1.0), 0.8).set_trans(Tween.TRANS_SINE)


# --- "Developed by RUN" fade loop ---
func animate_run_label():
	run_label.modulate = Color(1, 1, 1, 0)
	var tween = create_tween().set_loops()
	tween.tween_property(run_label, "modulate:a", 1.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(run_label, "modulate:a", 0.0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


# --- Sky effect by tweening background color ---
func animate_sky():
	bg_rect.modulate = Color(0.1, 0.1, 0.3, 1.0)  # start as night-ish blue

	var tween = create_tween().set_loops()

	# Transition night → dawn → day → sunset → night
	tween.tween_property(bg_rect, "modulate", Color(0.4, 0.3, 0.6, 1.0), 3.0) # dawn purple
	tween.tween_property(bg_rect, "modulate", Color(0.7, 0.8, 1.0, 1.0), 4.0) # day sky
	tween.tween_property(bg_rect, "modulate", Color(0.9, 0.5, 0.3, 1.0), 3.0) # sunset orange
	tween.tween_property(bg_rect, "modulate", Color(0.1, 0.1, 0.3, 1.0), 4.0) # night blue

func _on_start_pressed():
	var layer =  CanvasLayer.new()
	add_child(layer)
	var fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)

	# Make it full screen
	fade.anchor_left = 0
	fade.anchor_top = 0
	fade.anchor_right = 1
	fade.anchor_bottom = 1
	fade.offset_left = 0
	fade.offset_top = 0
	fade.offset_right = 0
	fade.offset_bottom = 0

	layer.add_child(fade)



	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 4).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(Callable(self, "_start_game_after_fade"))
	
func _start_game_after_fade():
	get_tree().change_scene_to_file("res://scenes/world.tscn")
