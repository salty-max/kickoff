class_name TournamentScreen
extends Screen

const STAGE_TEXTURES: Dictionary = {
	Tournament.Stage.QUARTERS: preload("res://assets/art/ui/teamselection/quarters-label.png"),
	Tournament.Stage.SEMIS: preload("res://assets/art/ui/teamselection/semis-label.png"),
	Tournament.Stage.FINAL: preload("res://assets/art/ui/teamselection/finals-label.png"),
	Tournament.Stage.COMPLETE: preload("res://assets/art/ui/teamselection/winner-label.png"),
}


@onready var stage_texture: TextureRect = %StageTexture
@onready var flag_containers: Dictionary = {
	Tournament.Stage.QUARTERS: [%QFLeftContainer, %QFRightContainer],
	Tournament.Stage.SEMIS: [%SFLeftContainer, %SFRightContainer],
	Tournament.Stage.FINAL: [%FinalLeftContainer, %FinalRightContainer],
	Tournament.Stage.COMPLETE: [%WinnerContainer],
}

var player_team: String = GameManager.player_setup[0]
var tournament: Tournament = null


func _ready() -> void:
	tournament = Tournament.new()
	refresh_brackets()
	
	
func _physics_process(_delta: float) -> void:
	if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SHOOT):
		tournament.advance()
		refresh_brackets()
	
	
func refresh_brackets() -> void:
	for stage in range(tournament.current_stage + 1):
		refresh_bracket(stage)
	
	
func refresh_bracket(stage: Tournament.Stage) -> void:
	var flag_nodes := get_flag_nodes(stage)
	stage_texture.texture = STAGE_TEXTURES.get(stage)
	if stage < Tournament.Stage.COMPLETE:
		var matches: Array = tournament.matches[stage]
		assert(flag_nodes.size() == 2 * matches.size())
		for i in range(matches.size()):
			var current_match: Match = matches[i]
			var home_flag: BracketFlag = flag_nodes[i * 2]
			var away_flag: BracketFlag = flag_nodes[i * 2 + 1]
			home_flag.texture = FlagHelper.get_texture(current_match.home_team)
			away_flag.texture = FlagHelper.get_texture(current_match.away_team)
			if not current_match.winner.is_empty():
				var winner_flag := home_flag if current_match.winner == current_match.home_team else away_flag
				var loser_flag := home_flag if winner_flag == away_flag else away_flag
				winner_flag.set_as_winner(current_match.final_score)
				loser_flag.set_as_loser()
			elif [current_match.home_team, current_match.away_team].has(player_team) and stage == tournament.current_stage:
				var player_flag := home_flag if current_match.home_team == player_team else away_flag
				player_flag.set_as_current_team()
				GameManager.current_match = current_match
	else:
		flag_nodes[0].texture = FlagHelper.get_texture(tournament.winner)
	
	
func get_flag_nodes(stage: Tournament.Stage) -> Array[BracketFlag]:
	var flag_nodes: Array[BracketFlag] = []
	for container in flag_containers.get(stage):
		for node in container.get_children():
			if node is BracketFlag:
				flag_nodes.append(node)
				
	return flag_nodes
