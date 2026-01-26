class_name GameStateData
extends RefCounted

var team_scored_on: String


static func build() -> GameStateData:
	return GameStateData.new()
	
	
func set_team_scored_on(team: String) -> GameStateData:
	team_scored_on = team
	return self
