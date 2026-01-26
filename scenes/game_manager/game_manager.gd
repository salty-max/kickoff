extends Node

const COUNTRIES := ["DEFAULT", "FRANCE", "ARGENTINA", "BRAZIL", "ENGLAND", "GERMANY", "ITALY", "SPAIN", "USA", "CANADA", "JAPAN", "PORTUGAL"]
const GAME_DURATION := 2 * 60 * 1000.0

enum State {
	GAME_OVER,
	IN_PLAY,
	KICKOFF,
	OVERTIME,
	RESET,
	SCORED,
}

var countries: Array[String] = ["FRANCE", "JAPAN"]
var score := [0, 0]
var time_left: float
var state_factory := GameStateFactory.new()
var current_state: GameState


func _ready() -> void:
	time_left = GAME_DURATION
	switch_state(State.IN_PLAY)
	
	
func get_home_country() -> String:
	return countries[0]
	
	
func get_away_country() -> String:
	return countries[1]
	

func add_to_score(_team_scored_on: String) -> void:
	var scoring_team_idx := 1 if _team_scored_on == countries[0] else 0
	score[scoring_team_idx] += 1
	
	
func set_away_team_score(_score: int) -> void:
	score[1] = _score
	
	
func switch_state(state: State, state_data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	var ctx := GameStateContext.build().set_manager(self).set_state_data(state_data)
	current_state.setup(ctx)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", State.keys()[state])
	
	call_deferred("add_child", current_state)
