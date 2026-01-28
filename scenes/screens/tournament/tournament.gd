class_name Tournament

enum Stage {
	QUARTERS,
	SEMIS,
	FINAL,
	COMPLETE
}

var current_stage: Stage = Stage.QUARTERS
var matches := {
	Stage.QUARTERS: [],
	Stage.SEMIS: [],
	Stage.FINAL: [],
}
var winner := ""


func _init() -> void:
	var countries := DataLoader.get_countries().slice(1, DataLoader.get_countries().size()).filter(
		func(c: String): return c != GameManager.player_setup[0]
	)
	countries.shuffle()
	countries = countries.slice(0, 7)
	countries.insert(randi_range(0, countries.size() - 1), GameManager.player_setup[0])
	create_bracket(Stage.QUARTERS, countries)
	
	
func create_bracket(stage: Stage, countries: Array[String]) -> void:
	for i in range(int(countries.size() / 2.0)):
		matches[stage].append(Match.new(countries[i * 2], countries[i * 2 + 1]))
		
		
func advance() -> void:
	if current_stage < Stage.COMPLETE:
		var stage_matches = matches[current_stage]
		var stage_winners: Array[String] = []
		for current_match: Match in stage_matches:
			current_match.resolve()
			stage_winners.append(current_match.winner)
		current_stage = current_stage + 1 as Stage
		if current_stage == Stage.COMPLETE:
			winner = stage_winners[0]
		else:
			create_bracket(current_stage, stage_winners)
