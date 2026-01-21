class_name PlayerState
extends Node

@warning_ignore("unused_signal")
signal state_transition_requested(new_state: Player.State)

var player: Player = null


func setup(ctx_player: Player) -> void:
	player = ctx_player
	
	
func _enter_tree() -> void:
	pass
	
	
func _exit_tree() -> void:
	pass
