class_name ScoreHelper

static func get_score_text(match: Match) -> String:
	return "%d - %d" % [match.home_goals, match.away_goals]
	
	
static func get_current_score_info(match: Match) -> String:
	if match.is_tied():
		return "TEAMS ARE TIED %d - %d" % [match.home_goals, match.away_goals]
	else:
		return "%s LEADS %s" % [match.winner, match.final_score]
		
		
static func get_final_score_info(match: Match) -> String:
		return "%s WINS %s" % [match.winner, match.final_score]
