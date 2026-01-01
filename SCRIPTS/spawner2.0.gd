extends Node

#action plan
#2 parts: storing and deloying
#storing: randomly pick an enemy out an array of possible choices
#		  then add it to an active array
#deploying: run through each item in the active array and run it
#			through a randomizer spawner
#varibles: each enemy will have a spawning starting time

#globals
@onready var globals = get_node("/root/Main Scene/Globals")
@onready var player = get_node("/root/Main Scene/player")

#enemies:
@export var SpaceSaw : PackedScene
@export var Curver : PackedScene
@export var Centipede : PackedScene
@export var Portal : PackedScene

#enemy starting level values
var SawStartLvl = 0
var CurverStartLvl = 3
var CentipedeStartLvl = 20
var PortalStartLvl = 5

#enemy triggers
var SawEnabled = true
var CurverEnabled = false
var CentipedeEnabled = false
var PortalEnabled = false

#base varibles
var waveTimer = 0
var waveDelay = 100
var waveSize = 3
var xSpawnOffset = 1000
var ySpawnOffset = 1000
var possibleEnemies = []
var preparedEnemies = []

func generateWave():
	while preparedEnemies.size() < waveSize:
		var possibleChoice = randi_range(0, possibleEnemies.size()-1)
		preparedEnemies.append(possibleEnemies[possibleChoice])

func deployWave():
	for i in range(preparedEnemies.size()):
		var tempRand = randi_range(1,4)
		var spawnedEnemy
		if tempRand == 1:
			spawnedEnemy = preparedEnemies[i].instantiate()
			spawnedEnemy.position.x = randf_range(-500-xSpawnOffset,500+xSpawnOffset)+player.position.x
			spawnedEnemy.position.y = -1000+player.position.y-ySpawnOffset
		elif tempRand == 2:
			spawnedEnemy = preparedEnemies[i].instantiate()
			spawnedEnemy.position.x = randf_range(-500-xSpawnOffset,500+xSpawnOffset)+player.position.x
			spawnedEnemy.position.y = 1000+player.position.y+ySpawnOffset
		elif tempRand == 3:
			spawnedEnemy = preparedEnemies[i].instantiate()
			spawnedEnemy.position.y = randf_range(-500-ySpawnOffset,500+ySpawnOffset)+player.position.y+ySpawnOffset
			spawnedEnemy.position.x = -1000+player.position.x-xSpawnOffset
		else:
			spawnedEnemy = preparedEnemies[i].instantiate()
			spawnedEnemy.position.y = randf_range(-500-ySpawnOffset,500+ySpawnOffset)+player.position.y+ySpawnOffset
			spawnedEnemy.position.x = 1000+player.position.x+xSpawnOffset
		owner.add_child(spawnedEnemy)
	preparedEnemies.clear()

func _ready():
	possibleEnemies.append(SpaceSaw)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_P):
			waveDelay = 10
	#run wave
	if waveTimer%waveDelay == 0 and globals.spawnEnemies == true:
		generateWave()
		deployWave()
	waveTimer+=1
	
	#add enemies to possibleEnemies
	if globals.points == CurverStartLvl and CurverEnabled == false:
		possibleEnemies.append(Curver)
		CurverEnabled = true
	if globals.points == CentipedeStartLvl and CentipedeEnabled == false:
		possibleEnemies.append(Centipede)
		CentipedeEnabled = true
	if globals.points == PortalStartLvl and PortalEnabled == false:
		possibleEnemies.append(Portal)
		PortalEnabled = true
