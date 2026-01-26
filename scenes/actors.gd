class_name Actors
extends Node2D

const WEIGHT_CACHE_DURATION := 200
const PLAYER_SCENE := preload("res://scenes/characters/player.tscn")

@export_category("Node References")
@export var ball: Ball
@export var home_goal: Goal
@export var away_goal: Goal

@onready var spawns: Node2D = $Spawns
@onready var kickoffs: Node2D = $Kickoffs

var home_team: Array[Player] = []
var away_team: Array[Player] = []
var time_since_last_cache := 0.0
var is_checking_for_kickoff_readiness := false


func _init() -> void:
	GameEvents.team_reset.connect(_on_team_reset)


func _ready() -> void:
	time_since_last_cache = 0.0
	home_team = _spawn_players(GameManager.get_home_country(), home_goal)
	home_goal.init(GameManager.get_home_country())
	spawns.scale.x = -1
	kickoffs.scale.x = -1
	away_team = _spawn_players(GameManager.get_away_country(), away_goal)
	away_goal.init(GameManager.get_away_country())
	
	_setup_control_schemes()
	
	
func _physics_process(delta: float) -> void:
	time_since_last_cache += delta * 1000.0
	if time_since_last_cache > WEIGHT_CACHE_DURATION:
		_set_on_duty_weights()
		time_since_last_cache = 0.0
		
	if is_checking_for_kickoff_readiness:
		_check_for_kickoff_readiness()
	
	
func _spawn_players(country: String, goal: Goal) -> Array[Player]:
	var players := DataLoader.get_team(country)
	var player_nodes: Array[Player] = []
	var target_goal := home_goal if goal == away_goal else away_goal
	for i in players.size():
		var player_position: Vector2 = spawns.get_child(i).global_position
		var player_data: PlayerData = players[i]
		var kickoff_position := player_position
		if i > 3:
			kickoff_position = kickoffs.get_child(i - 4).global_position as Vector2
		var player := _spawn_player(player_position, goal, target_goal, country, kickoff_position, player_data)
		player_nodes.append(player)
		add_child(player)
	
	return player_nodes
	
func _spawn_player(_player_position: Vector2, _own_goal: Goal, _target_goal: Goal, country: String, _kickoff_position: Vector2, _player_data: PlayerData) -> Player:
	var player: Player = PLAYER_SCENE.instantiate()
	player.init(_player_position, ball, _own_goal, _target_goal, country, _kickoff_position, _player_data)
	player.swap_requested.connect(_on_player_swap_requested)
	
	return player
	
	
func _setup_control_schemes() -> void:
	_reset_control_schemes()
	var p1_country := GameManager.player_setup[0]
	if GameManager.is_coop():
		var player_team := home_team if home_team[0].country == p1_country else away_team
		player_team[4].set_control_scheme(Player.ControlScheme.P1)
		player_team[5].set_control_scheme(Player.ControlScheme.P2)
	elif GameManager.is_single_player():
		var player_team := home_team if home_team[0].country == p1_country else away_team
		player_team[5].set_control_scheme(Player.ControlScheme.P1)
	else:
		var p1_team := home_team if home_team[0].country == p1_country else away_team
		var p2_team := home_team if p1_team == away_team else away_team
		p1_team[5].set_control_scheme(Player.ControlScheme.P1)
		p2_team[5].set_control_scheme(Player.ControlScheme.P2)
		
		
func _reset_control_schemes() -> void:
	for team in [home_team, away_team]:
		for player: Player in team:
			player.set_control_scheme(Player.ControlScheme.CPU)
	
	
func _check_for_kickoff_readiness() -> void:
	for team in [home_team, away_team]:
		for player: Player in team:
			if not player.is_ready_for_kickoff():
				return
				
	_setup_control_schemes()
	is_checking_for_kickoff_readiness = false
	GameEvents.kickoff_ready.emit()
	
	
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
			
			
func _on_player_swap_requested(requester: Player) -> void:
	var team := home_team if requester.country == home_team[0].country else away_team
	var cpu_players: Array[Player] = team.filter(
		func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALKEEPER
	)
	cpu_players.sort_custom(func(p1: Player, p2: Player): 
		return p1.position.distance_squared_to(ball.position) < p2.position.distance_squared_to(ball.position)
	)
	var closest_cpu_to_ball: Player = cpu_players[0]
	if closest_cpu_to_ball.position.distance_squared_to(ball.position) < requester.position.distance_squared_to(ball.position):
		var player_control_scheme := requester.control_scheme
		requester.set_control_scheme(Player.ControlScheme.CPU)
		closest_cpu_to_ball.set_control_scheme(player_control_scheme)
		
		
func _on_team_reset() -> void:
	is_checking_for_kickoff_readiness = true
