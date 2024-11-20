class_name Player
extends RigidBody2D

@export var startingPositionY = 75
@export_color_no_alpha var color = Color("000000")

@onready var mesh_instance_2d = $MeshInstance2D

var holed = false
var started = false
var playerName = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = startingPositionY
	
	var gradient = Gradient.new()
	gradient.set_color(0.0, color)
	gradient.set_color(1, color)
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	mesh_instance_2d.texture = gradient_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if holed:
		#sleeping = true
	#elif sleeping and started:
		#sleeping = false
		#position.y = startingPositionY
	pass
