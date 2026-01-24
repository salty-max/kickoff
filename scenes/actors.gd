class_name Actors
extends Node2D

const WEIGHT_CACHE_DURATION := 200
const PLAYER_SCENE := preload("res://scenes/characters/player.tscn")

@export_category("Node References")
@export var ball: Ball
@export var home_goal: Goal
@export var away_goal: Goal

@export_category("Playing Teams")
@export var home_country: String
@export var away_country: String

@onready var spawns: Node2D = $Spawns

var home_team: Array[Player] = []
var away_team: Array[Player] = []
var time_since_last_cache := 0.0


func _ready() -> void:
	time_since_last_cache = 0.0
	home_team = _spawn_players(home_country, home_goal)
	spawns.scale.x = -1
	away_team = _spawn_players(away_country, away_goal)
	
	var player: Player = get_children().filter(func(p): return p is Player)[4]
	player.control_scheme = Player.ControlScheme.P1
	player.set_control_texture()
	
	
func _physics_process(delta: float) -> void:
	time_since_last_cache += delta * 1000.0
	if time_since_last_cache > WEIGHT_CACHE_DURATION:
		_set_on_duty_weights()
		time_since_last_cache = 0.0
	
	
func _spawn_players(country: String, goal: Goal) -> Array[Player]:
	var players := DataLoader.get_team(country)
	var player_nodes: Array[Player] = []
	var target_goal := home_goal if goal == away_goal else away_goal
	for i in players.size():
		var player_position: Vector2 = spawns.get_child(i).global_position
		var player_data: PlayerData = players[i]
		var player := _spawn_player(player_position, goal, target_goal, country, player_data)
		player_nodes.append(player)
		add_child(player)
	
	return player_nodes
	
func _spawn_player(_player_position: Vector2, _own_goal: Goal, _target_goal: Goal, country: String, _player_data: PlayerData) -> Player:
	var player := PLAYER_SCENE.instantiate()
	player.init(_player_position, ball, _own_goal, _target_goal, country, _player_data)
	
	return player
	
	
func _set_on_duty_weights() -> void:
	for team in [home_team, away_team]:
		var cpu_players: Array[Player] = team.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALKEEPER
		)
		cpu_players.sort_custom(func(p1: Player, p2: Player): 
			return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position)
		)
		
		for i in range(cpu_players.size()):
			cpu_players[i].weight_on_duty_steering = 1 - ease(float(i) / 10.0, 0.1)
