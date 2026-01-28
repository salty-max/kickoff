class_name Player
extends CharacterBody2D

@warning_ignore("unused_signal")
signal swap_requested(player: Player)

const CONTROL_SCHEME_SPRITES_MAP: Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const GRAVITY := 8.0
const BALL_CONTROL_MAX_HEIGHT := 10.0
const WALK_ANIM_THRESHOLD := 0.6

enum ControlScheme {
	CPU,
	P1,
	P2
}

enum State {
	BICYCLE,
	CELEBRATING,
	CHEST_CONTROL,
	DIVING,
	HEADER,
	HURT,
	MOURNING,
	MOVING,
	PASSING,
	PREPPING_SHOT,
	RECOVERING,
	RESETING,
	SHOOTING,
	TACKLING,
	VOLLEY,
}

enum Role {
	GOALKEEPER,
	DEFENSER,
	MIDFIELDER,
	FORWARD
}

enum SkinColor {
	LIGHT,
	MEDIUM,
	DARK
}

@export var control_scheme: ControlScheme
@export var speed: float = 80.0
@export var power: float = 70.0
@export var ball: Ball
@export var own_goal: Goal
@export var target_goal: Goal

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var teammate_detection_area: Area2D = $TeammateDetectionArea
@onready var ball_detection_area: Area2D = $BallDetectionArea
@onready var tackle_hitbox: Area2D = $TackleHitbox
@onready var opponent_detection_area: Area2D = $OpponentDetectionArea
@onready var permanent_damage_emitter_area: Area2D = $PermanentDamageEmitterArea
@onready var goalie_hands_collider: CollisionShape2D = %GoalieHandsCollider
@onready var root_particles: Node2D = %RootParticles
@onready var run_particles: GPUParticles2D = %RunParticles


var full_name: String
var country: String
var role: Role
var skin_color: SkinColor
var facing := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()
var current_ai_behavior: AIBehavior
var ai_behavior_factory := AIBehaviorFactory.new()
var spawn_position := Vector2.ZERO
var kickoff_position := Vector2.ZERO
var weight_on_duty_steering := 0.0


func _ready() -> void:
	setup_ai_behavior()
	set_control_texture()
	set_shader_properties()
	permanent_damage_emitter_area.monitoring = role == Role.GOALKEEPER
	permanent_damage_emitter_area.body_entered.connect(_on_tackle_player)
	goalie_hands_collider.disabled = role != Role.GOALKEEPER
	spawn_position = position
	tackle_hitbox.body_entered.connect(_on_tackle_player)
	GameEvents.team_scored.connect(_on_team_scored)
	GameEvents.game_over.connect(_on_game_over)
	var initial_position := kickoff_position if country == GameManager.current_match.home_team else spawn_position
	var data := PlayerStateData.build().set_reset_position(initial_position)
	switch_state(State.RESETING, data)


func _physics_process(delta: float) -> void:
	set_facing()
	set_sprites_visibility()
	flip_sprites()
	process_gravity(delta)
	move_and_slide()
	
	
func init(_position: Vector2, _ball: Ball, _own_goal: Goal, _target_goal: Goal, _country: String, _kickoff_position: Vector2, _data: PlayerData) -> void:
	position = _position
	kickoff_position = _kickoff_position
	ball = _ball
	own_goal = _own_goal
	target_goal = _target_goal
	speed = _data.speed
	power = _data.power
	full_name = _data.name
	role = _data.role
	skin_color = _data.skin_color
	country = _country
	facing = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT
	name = "%s_%s_%s" % [country, role, full_name]
	
	
func setup_ai_behavior() -> void:
	current_ai_behavior = ai_behavior_factory.get_ai_behavior(role)
	current_ai_behavior.setup(self, ball, opponent_detection_area, teammate_detection_area)
	current_ai_behavior.name = "AIBehavior"
	add_child(current_ai_behavior)


func set_shader_properties() -> void:
	sprite.material.set_shader_parameter("team_palette", load("res://assets/art/palettes/teams-color-palette.png"))
	sprite.material.set_shader_parameter("skin_color", skin_color)
	var countries := DataLoader.get_countries()
	var country_color := countries.find(country)
	country_color = clampi(country_color, 0, countries.size() - 1)
	sprite.material.set_shader_parameter("team_color", country_color)


func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height < 0:
			height = 0
			
	sprite.position = Vector2.UP * height
	
	
func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	var ctx := PlayerStateContext.build().set_player(self).set_ball(ball).set_teammate_detection_area(teammate_detection_area).set_ball_detection_area(ball_detection_area).set_state_data(state_data).set_target_goal(target_goal).set_ai_behavior(current_ai_behavior).set_tackle_hitbox(tackle_hitbox)
	current_state.setup(ctx)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", State.keys()[state])
	
	call_deferred("add_child", current_state)
		
		
func set_facing() -> void:
	if velocity.x > 0:
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		facing = Vector2.LEFT
		
		
func set_movement_animation() -> void:
	if velocity.length() < 1:
		update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.IDLE))
	elif velocity.length() < speed * WALK_ANIM_THRESHOLD:
		update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.WALK))
	else:
		update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.RUN))
		
		
func flip_sprites() -> void:
	if facing == Vector2.RIGHT:
		sprite.flip_h = false
		tackle_hitbox.scale.x = 1
		opponent_detection_area.scale.x = 1
		root_particles.scale.x = 1
	else:
		sprite.flip_h = true
		tackle_hitbox.scale.x = -1
		opponent_detection_area.scale.x = -1
		root_particles.scale.x = -1
		
		
func set_sprites_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU
	run_particles.emitting = velocity.length() == speed
		
		
func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_SPRITES_MAP[control_scheme]
	
	
func set_control_scheme(scheme: ControlScheme) -> void:
	control_scheme = scheme
	set_control_texture()
	

func update_animation(anim_name: String) -> void:
	assert(animation_player.has_animation(anim_name), str("No animation named %s for Player", [anim_name]))
	animation_player.play(anim_name)
	
	
func can_carry_ball() -> bool:
	return current_state != null and current_state.can_carry_ball()
		
		
func has_ball() -> bool:
	return ball.get_carrier() == self
	
	
func is_ready_for_kickoff() -> bool:
	return current_state != null and current_state.is_ready_for_kickoff()
	
	
func control_ball() -> void:
	if ball.height > BALL_CONTROL_MAX_HEIGHT:
		switch_state(State.CHEST_CONTROL)
		
		
func get_hurt(hurt_origin: Vector2) -> void:
	var data := PlayerStateData.build().set_hurt_direction(hurt_origin)
	switch_state(State.HURT, data)
	
	
func get_pass_request(player: Player) -> void:
	if ball.get_carrier() == self and current_state != null and current_state.can_pass():
		var data := PlayerStateData.build().set_pass_target(player)
		switch_state(State.PASSING, data)
		
		
func is_facing_target_goal() -> bool:
	var direction_to_target_goal = position.direction_to(target_goal.position)
	return facing.dot(direction_to_target_goal) > 0
	
	
func face_towards_target_goal() -> void:
	if not is_facing_target_goal():
		facing = facing * -1
	
	
func _on_tackle_player(body: Player) -> void:
	if body != self and body.country != country and body.has_ball():
		body.get_hurt(position.direction_to(body.position))
	
	
func _on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
		
		
func _on_team_scored(country_scored_on: String) -> void:
	if country_scored_on == country:
		switch_state(State.MOURNING)
	else:
		switch_state(State.CELEBRATING)
		
		
func _on_game_over(winning_team: String) -> void:
	if winning_team == country:
		switch_state(State.CELEBRATING)
	else:
		switch_state(State.MOURNING)
