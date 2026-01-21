class_name Ball
extends AnimatableBody2D

enum State {
	CARRIED,
	FREEFORM,
	SHOT
}

@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state: BallState = null
var carrier: Player = null


func _ready() -> void:
	switch_state(State.FREEFORM)


func switch_state(state: Ball.State) -> void:
	if current_state != null:
		remove_child(current_state)
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, carrier, player_detection_area)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", Ball.State.keys()[state])
	
	call_deferred("add_child", current_state)
	
	
func update_animation(anim_name: String, backwards: bool = false) -> void:
	assert(animation_player.has_animation(anim_name), str("No animation named %s for Ball", [anim_name]))
	if backwards:
		animation_player.play_backwards(anim_name)
	else:
		animation_player.play(anim_name)
