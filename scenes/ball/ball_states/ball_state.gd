class_name BallState
extends Node

@warning_ignore("unused_signal")
signal state_transition_requested(new_state: Ball.State)

var ball: Ball = null
var carrier: Player = null
var player_detection_area: Area2D = null


func setup(_ball: Ball, _carrier: Player, _detection_area: Area2D) -> void:
	ball = _ball
	carrier = _carrier
	player_detection_area = _detection_area
