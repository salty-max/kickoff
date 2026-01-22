class_name PlayerStatePassing
extends PlayerState


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.KICK))
	player.velocity = Vector2.ZERO
	
	
func on_animation_complete() -> void:
	var pass_target := _find_teammate_in_view()
	ball.pass_to(pass_target.position)
	transition_to(Player.State.MOVING)
	
	
func _find_teammate_in_view() -> Player:
	var players_in_view := teammate_detection_area.get_overlapping_bodies()
	var teammates_in_view := players_in_view.filter(
		# TODO: Filter only the player team
		func(p: Player): return p != player
	)
	teammates_in_view.sort_custom(
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) < p2.position.distance_squared_to(player.position)
	)
	
	if teammates_in_view.size() > 0:
		return teammates_in_view[0]
		
	return null
