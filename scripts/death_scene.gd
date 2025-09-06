extends Node2D

@onready var top_spotlight: Sprite2D = $top_spotlight
@onready var bottom_spotlight: Sprite2D = $bottom_spotlight
@onready var retry_button: Button = $Button

var flicker_rng = RandomNumberGenerator.new()

# --- restart game
const WORLD = preload("res://scenes/world.tscn")
# ---- display the score
@onready var score_label: Label = $score_label

func _ready():
	score_label.text = "Your Score: " + str(global.last_score)
	retry_button.connect("pressed", Callable(self,"_on_retry_pressed"))
	# Initial states
	top_spotlight.modulate = Color(1, 1, 1, 0.2)
	bottom_spotlight.modulate = Color(1, 1, 1, 0.2)
	retry_button.visible = false

	spotlight_intro()


# --- Spotlight intro ---
func spotlight_intro():
	var tween = create_tween()

	# blink a few times
	for i in range(3):
		tween.tween_property(top_spotlight, "modulate:a", 0.0, 0.15)
		tween.parallel().tween_property(bottom_spotlight, "modulate:a", 0.0, 0.15)
		tween.tween_property(top_spotlight, "modulate:a", 0.3, 0.15)
		tween.parallel().tween_property(bottom_spotlight, "modulate:a", 0.3, 0.15)

	# then fade in fully
	tween.tween_property(top_spotlight, "modulate:a", 1.0, 0.5)
	tween.parallel().tween_property(bottom_spotlight, "modulate:a", 1.0, 0.5)

	tween.tween_callback(Callable(self, "start_button_and_flicker"))


# --- After spotlight intro ---
func start_button_and_flicker():
	retry_button.visible = true
	fade_in_and_pulse_button()
	start_flicker_loop()


# --- Button effects ---
func fade_in_and_pulse_button():
	retry_button.modulate = Color(1, 1, 1, 0)
	retry_button.scale = Vector2.ONE

	var tween = create_tween()
	tween.tween_property(retry_button, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "pulse_button"))


func pulse_button():
	var pulse = create_tween().set_loops()
	pulse.tween_property(retry_button, "scale", Vector2(1.1, 1.1), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(retry_button, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.parallel().tween_property(retry_button, "modulate", Color(1.2, 1.2, 1.2, 1), 0.6)
	pulse.parallel().tween_property(retry_button, "modulate", Color(1, 1, 1, 1), 0.6)


# --- Spotlight flicker effect ---
func start_flicker_loop():
	flicker_rng.randomize()
	flicker_once()


func flicker_once():
	var delay = flicker_rng.randf_range(1.0, 3.0)  # random wait between flicker sets
	var tween = create_tween()
	tween.tween_interval(delay)

	# do 2–4 quick flickers
	var flicker_count = flicker_rng.randi_range(2, 4)
	for i in range(flicker_count):
		var dim = flicker_rng.randf_range(0.3, 0.7)
		tween.tween_property(top_spotlight, "modulate:a", dim, 0.1)
		tween.parallel().tween_property(bottom_spotlight, "modulate:a", dim, 0.1)
		tween.tween_property(top_spotlight, "modulate:a", 1.0, 0.15)
		tween.parallel().tween_property(bottom_spotlight, "modulate:a", 1.0, 0.15)

	# loop
	tween.tween_callback(Callable(self, "flicker_once"))

func _on_retry_pressed():
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
