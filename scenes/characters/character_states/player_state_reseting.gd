class_name PlayerStateReseting
extends PlayerState

var has_arrived := false


func _physics_process(_delta: float) -> void:
	if not has_arrived:
		var direction := player.position.direction_to(state_data.reset_position)
		if player.position.distance_to(state_data.reset_position) < 2:
			has_arrived = true
			player.velocity = Vector2.ZERO
		else:
			player.velocity = direction * player.speed
		
		player.set_movement_animation()
		player.face_towards_target_goal()
		
		
		
func is_ready_for_kickoff() -> bool:
	return has_arrived
	
