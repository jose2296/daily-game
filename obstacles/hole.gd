extends Node2D

@onready var close_bar = $CloseBar
@onready var collisionShape2D = $CloseBar/CollisionShape2D

@export var holed = false

var score = round(randf_range(5, 100))
signal playerHoled(playerName, score)

# Called when the node enters the scene tree for the first time.
func _ready():
	close_bar.hide()
	collisionShape2D.disabled = true 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	close_bar.visible = holed
	collisionShape2D.disabled = !holed 
		
func _on_area_2d_body_entered(body):
	if body is Player:
		holed = true
		body.holed = true
		playerHoled.emit(body.name, score)
