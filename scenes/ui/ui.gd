class_name UI
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flag_textures: Array[TextureRect] = [%HomeFlag, %AwayFlag]
@onready var player_label: Label = %PlayerLabel
@onready var score_label: Label = %ScoreLabel
@onready var time_label: Label = %TimeLabel
@onready var goal_scorer_label: Label = %GoalScorerLabel
@onready var score_info_label: Label = %ScoreInfoLabel

var last_ball_carrier: String

func _ready() -> void:
	_update_score()
	_update_flags()
	_update_clock()
	player_label.text = ""
	GameEvents.ball_carried.connect(_on_ball_carried)
	GameEvents.ball_released.connect(_on_ball_released)
	GameEvents.score_changed.connect(_on_score_changed)
	GameEvents.team_reset.connect(_on_team_reset)
	GameEvents.game_over.connect(_on_game_over)
	
	
func _physics_process(_delta: float) -> void:
	_update_clock()
	
	
func _update_score() -> void:
	score_label.text = ScoreHelper.get_score_text(GameManager.current_match)
	
	
func _update_flags() -> void:
	for i in flag_textures.size():
		var countries := [GameManager.current_match.home_team, GameManager.current_match.away_team]
		flag_textures[i].texture = FlagHelper.get_texture(countries[i])


func _update_clock() -> void:
	if GameManager.time_left < 0:
		time_label.modulate = Color.YELLOW
	time_label.text = TimeHelper.get_time_text(GameManager.time_left)
	
	
func _on_ball_carried(carrier_name: String) -> void:
	player_label.text = carrier_name
	last_ball_carrier = carrier_name
	
	
func _on_ball_released() -> void:
	player_label.text = ""
	
	
func _on_score_changed() -> void:
	if not GameManager.is_time_up():
		goal_scorer_label.text = "%s SCORED!" % [last_ball_carrier]
		score_info_label.text = ScoreHelper.get_current_score_info(GameManager.current_match)
		animation_player.play("goal_appear")
	_update_score()
	
	
func _on_team_reset() -> void:
	if GameManager.current_match.has_someone_scored():
		animation_player.play("goal_hide")
	
	
func _on_game_over(_winner_country: String) -> void:
	score_info_label.text = ScoreHelper.get_final_score_info(GameManager.current_match)
	animation_player.play("game_over")
