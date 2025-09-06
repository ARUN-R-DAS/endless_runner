extends RigidBody2D

func _ready():
	gravity_scale = .5  # falls faster
	linear_damp = 5    # slows sideways drift
	angular_velocity = .2 # stop spinning (or give a spin if you want goofy!)
