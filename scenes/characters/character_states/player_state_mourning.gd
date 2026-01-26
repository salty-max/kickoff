class_name PlayerStateMourning
extends PlayerState


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.MOURN))
	player.velocity = Vector2.ZERO
	GameEvents.team_reset.connect(_on_team_reset)
	
	
func _on_team_reset() -> void:
	var data := PlayerStateData.build().set_reset_position(player.kickoff_position)
	transition_to(Player.State.RESETING, data)
