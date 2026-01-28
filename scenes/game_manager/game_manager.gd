extends Node

const GAME_DURATION := 2 * 60 * 1000.0
const IMPACT_PAUSE_DURATION := 100.0

enum State {
	GAME_OVER,
	IN_PLAY,
	KICKOFF,
	OVERTIME,
	RESET,
	SCORED,
}

var player_setup: Array[String] = ["FRANCE", "BRAZIL"]
var time_left: float
var state_factory := GameStateFactory.new()
var current_match: Match = null
var current_state: GameState
var time_since_paused := Time.get_ticks_msec()


func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS


func _ready() -> void:
	time_left = GAME_DURATION
	GameEvents.impact_received.connect(_on_impact_received)
	time_since_paused = Time.get_ticks_msec()
	
	
func _process(_delta: float) -> void:
	if get_tree().paused and Time.get_ticks_msec() - time_since_paused > IMPACT_PAUSE_DURATION:
		get_tree().paused = false
		
		
func start_game() -> void:
	switch_state(State.RESET)
	
	
func switch_state(state: State, state_data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	var ctx := GameStateContext.build().set_manager(self).set_state_data(state_data)
	current_state.setup(ctx)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", State.keys()[state])
	
	call_deferred("add_child", current_state)
	
	
func add_to_score(_team_scored_on: String) -> void:
	current_match.increase_score(_team_scored_on)
	GameEvents.score_changed.emit()
	
	
func get_winner_country() -> String:
	assert(not current_match.is_tied())
	return current_match.winner
	
	
func is_time_up() -> bool:
	return time_left <= 0
	
	
func is_coop() -> bool:
	return player_setup[0] == player_setup[1]
	
	
func is_single_player() -> bool:
	return player_setup[1].is_empty()
	
	
func _on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_paused = Time.get_ticks_msec()
		get_tree().paused = true
