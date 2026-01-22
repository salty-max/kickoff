class_name Actors
extends Node2D

const PLAYER_SCENE := preload("res://scenes/characters/player.tscn")

@export_category("Node References")
@export var ball: Ball
@export var home_goal: Goal
@export var away_goal: Goal

@export_category("Playing Teams")
@export var home_team: String
@export var away_team: String

@onready var spawns: Node2D = $Spawns


func _ready() -> void:
	_spawn_players(home_team, home_goal)
	spawns.scale.x = -1
	_spawn_players(away_team, away_goal)
	
	var player: Player = get_children().filter(func(p): return p is Player)[4]
	player.control_scheme = Player.ControlScheme.P1
	player.set_control_texture()
	
	
func _spawn_players(country: String, goal: Goal) -> void:
	var players := DataLoader.get_team(country)
	var target_goal := home_goal if goal == away_goal else away_goal
	for i in players.size():
		var player_position: Vector2 = spawns.get_child(i).global_position
		var player_data: PlayerData = players[i]
		var player := _spawn_player(player_position, ball, goal, target_goal, player_data)
		add_child(player)
	
	
func _spawn_player(_player_position: Vector2, _ball: Ball, _own_goal: Goal, _target_goal: Goal, _player_data: PlayerData) -> Player:
	var player := PLAYER_SCENE.instantiate()
	player.init(_player_position, _ball, _own_goal, _target_goal, _player_data)
	
	return player
