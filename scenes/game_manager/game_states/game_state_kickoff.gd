class_name GameStateKickoff
extends GameState

var valid_control_schemes: Array[Player.ControlScheme] = []


func _enter_tree() -> void:
	var country_starting := state_data.team_scored_on
	if country_starting.is_empty():
		country_starting = manager.current_match.home_team
	if country_starting == manager.player_setup[0]:
		valid_control_schemes.append(Player.ControlScheme.P1)
	if country_starting == manager.player_setup[1]:
		valid_control_schemes.append(Player.ControlScheme.P2)
	if valid_control_schemes.size() == 0:
		valid_control_schemes.append(Player.ControlScheme.P1)
		
		
func _physics_process(_delta: float) -> void:
	for scheme in valid_control_schemes:
		if KeyUtils.is_action_just_pressed(scheme, KeyUtils.Action.PASS):
			GameEvents.kickoff_started.emit()
			SoundPlayer.play(SoundPlayer.Sound.WHISTLE)
			transition_to(GameManager.State.IN_PLAY)
