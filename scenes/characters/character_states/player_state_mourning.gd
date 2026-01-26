class_name PlayerStateMourning
extends PlayerState


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.MOURN))
	player.velocity = Vector2.ZERO
