class_name Match

var home_team: String
var away_team: String
var home_goals: int
var away_goals: int
var final_score: String
var winner: String


func _init(_home_team: String, _away_team: String) -> void:
	home_team = _home_team
	away_team = _away_team
	
	
func is_tied() -> bool:
	return home_goals == away_goals
	
	
func has_someone_scored() -> bool:
	return home_goals > 0 or away_goals > 0
	
	
func increase_score(team_scored_on: String) -> void:
	if team_scored_on == home_team:
		away_goals += 1
	else:
		home_goals += 1
	
	update_match_info()
		
		
func update_match_info() -> void:
	winner = home_team if home_goals > away_goals else away_team
	final_score = "%d - %d" % [max(home_goals, away_goals), min(home_goals, away_goals)]
	
	
func resolve() -> void:
	var home_power := _get_team_power(home_team)
	var away_power := _get_team_power(away_team)
	var diff := (home_power - away_power) / 400.0
	
	while is_tied():
		home_goals = max(0, int(round(randfn(1.3 + diff, 1.1))))
		away_goals = max(0, int(round(randfn(1.3 - diff, 1.1))))
	update_match_info()


func _get_team_power(team: String) -> float:
	var players := DataLoader.get_team(team)
	var total_power := 0.0
	for p: PlayerData in players:
		total_power += p.speed + p.power
	return total_power
