extends Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_body_entered(body: Node2D) -> void:
	if "IS_PLAYER" in body and body.IS_PLAYER:
		if body.health <5:
			body.health += 1
			audio_stream_player.stream = preload("res://music/powerUp.wav")
			var sound = audio_stream_player.duplicate()
			get_tree().current_scene.add_child(sound)
			sound.play()
			queue_free()
	
