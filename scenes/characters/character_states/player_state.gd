class_name PlayerState
extends Node

@warning_ignore("unused_signal")
signal state_transition_requested(new_state: Player.State)

var player: Player = null


func setup(_player: Player) -> void:
	player = _player
