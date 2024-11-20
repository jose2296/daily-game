extends Node2D

@export var players: Array[PlayerModel]
@onready var timeLabel = $UI/Time
@onready var restartButton := $UI/RestartButton
@onready var sendButton := $UI/SendButton
@onready var playersNode = $Players
@onready var obstaclesNode = $Obstacles

const ballScene = preload("res://components/ball.tscn")
const circleObstableRowScene = preload("res://obstacles/CircleObstablesRow.tscn")
var initialTime = 5
var time = initialTime
var rowMovementSpeed = 150
var rowMovementLimitOffset = 60
var ballSize = 85
var width = 1000
var gapBetweenPlayers = ballSize / 3

var raceResult = []
var scores = []

func _ready():
	restartButton.hide()
	sendButton.hide()
	timeLabel.text = 'Start in %s' %time
	
	create_row(400)
	create_row(600)
	createPlayers()
	
	#for hole in holes.get_children():
		#if hole.has_signal('playerHoled'):
			#hole.connect('playerHoled', onPlayerHole)
			
			
func onPlayerHole(playerName):
	raceResult.append({ "name": playerName, "score": scores[raceResult.size()] })
	
	if raceResult.size() == players.size():
		raceResult.reverse()
		finish()

func finish():
	timeLabel.text = ""
	for index in raceResult.size():
		timeLabel.text += str(index + 1) + " - " + raceResult[index].name + " (" + str(raceResult[index].score) + ")\n"
	timeLabel.visible = true
	restartButton.visible = true
	restartButton.connect('pressed', restart)
	sendButton.visible = true
	sendButton.connect('pressed', sendResultToWeb)
	
func sendResultToWeb():
	print('Sending score...')
	var text = """
		window.parent.postMessage({ type: 'finishRace', data: JSON.parse('%s') }, '*');
	""" % JSON.stringify(raceResult) 
	JavaScriptBridge.eval(text)
	
func createPlayers():
	var playersWidth = (players.size() * ballSize) + ((players.size() - 1) * gapBetweenPlayers)
	var firstPlayerPositionX = (get_viewport().size.x / 2) - (playersWidth / 2) + ballSize / 2
	players.shuffle()
	scores = []
	for index in players.size():
		var player = players[index]
		var positionX = firstPlayerPositionX + ((ballSize + gapBetweenPlayers) * index)
		create_new_player(player, positionX)
		scores.append((index + 1) * 10)

	scores.reverse()

func restart():
	for player in playersNode.get_children():
		player.queue_free()
	createPlayers()
	$Timer.start()
	time = initialTime
	timeLabel.text = 'Start in %s' %time
	timeLabel.visible = true
	restartButton.hide()
	sendButton.hide()
	($Barrier as StaticBody2D).visible = true
	($Barrier/CollisionShape2D as CollisionShape2D).disabled = false
	raceResult = []

	
func create_new_player(player: PlayerModel, positionX: int):
	var newballInstance = ballScene.instantiate()
	newballInstance.playerName = player.name
	newballInstance.color = player.color
	newballInstance.position.x = positionX
	playersNode.add_child(newballInstance)

func start_game():
	clear_ui()
	for player in playersNode.get_children():
		player.sleeping = false
		player.started = true

func create_row(positionY):
	var newRowScene = circleObstableRowScene.instantiate()
	newRowScene.position.y = positionY
	obstaclesNode.add_child(newRowScene)

func clear_ui():
	$Timer.stop()
	timeLabel.hide()
	($Barrier as StaticBody2D).hide()
	($Barrier/CollisionShape2D as CollisionShape2D).disabled = true
	#$Barrier.queue_free()
	# If Player has "can_sleep" as true need to awake each player
	#for player in playersNode.get_children():
		#(player as Player).sleeping = false

func _on_timer_timeout():
	time -= 1
	if (time <= 0):
		start_game()
		
	timeLabel.text = 'Start in %s' %time

func _on_finish_body_entered(body):
	if body is Player:
		body.holed = true
		body.set_collision_layer_value(1, false)
		body.set_collision_layer_value(2, true)
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)
		body.sleeping = true
		onPlayerHole(body.playerName)
		#playerHoled.emit(body.name, score)
