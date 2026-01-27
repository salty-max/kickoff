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

var countries: Array[String] = ["FRANCE", "BRAZIL"]
var player_setup: Array[String] = ["FRANCE", "BRAZIL"]
var score: Array[int] = [0, 0]
var time_left: float
var state_factory := GameStateFactory.new()
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
	var scoring_team_idx := 1 if _team_scored_on == countries[0] else 0
	score[scoring_team_idx] += 1
	GameEvents.score_changed.emit()
	
	
func set_away_team_score(_score: int) -> void:
	score[1] = _score
	
	
func get_home_country() -> String:
	return countries[0]
	
	
func get_away_country() -> String:
	return countries[1]
	
	
func get_winner_country() -> String:
	assert(not is_game_tied())
	return countries[0] if score[0] > score[1] else countries[1]
	
	
func is_game_tied() -> bool:
	return score[0] == score[1]
	
	
func is_time_up() -> bool:
	return time_left <= 0
	
	
func has_someone_scored() -> bool:
	return score[0] > 0 or score[1] > 0
	
	
func is_coop() -> bool:
	return player_setup[0] == player_setup[1]
	
	
func is_single_player() -> bool:
	return player_setup[1].is_empty()
	
	
func _on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_paused = Time.get_ticks_msec()
		get_tree().paused = true
