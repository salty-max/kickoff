class_name PlayerStateTackling
extends PlayerState

const TACKLE_DURATION := 200

var time_start_tackle := Time.get_ticks_msec()


func _enter_tree() -> void:
	time_start_tackle = Time.get_ticks_msec()
	player.update_animation("tackle")


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_tackle > TACKLE_DURATION:
		state_transition_requested.emit(Player.State.RECOVERING)
