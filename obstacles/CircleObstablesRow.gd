extends Node2D

#@export var startPosition: Vector2
var direction
var speed
var offset

# Called when the node enters the scene tree for the first time.
func _ready():
	var positionXRange = [-100, 100]
	var positionX = randf_range(positionXRange[0], positionXRange[1])
	var speedRange = [120, 170]
	var offsetRange = [50, 100]
	
	position.x = positionX
	direction = 1 if randf() > 0.5 else -1
	speed = randf_range(speedRange[0], speedRange[1])
	offset = randf_range(offsetRange[0], offsetRange[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * speed * delta
	if position.x < -offset:
		position.x = -offset
		direction = 1  # Cambiar a derecha
	elif position.x > offset:
		position.x = offset
		direction = -1  # Cambiar a izquierda
	pass
