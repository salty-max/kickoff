class_name BallStateFreeform
extends BallState


func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered)
	
	
func _on_player_entered(body: Player) -> void:
	var data := BallStateData.build().set_carrier(body)
	transition_to(Ball.State.CARRIED, data)
