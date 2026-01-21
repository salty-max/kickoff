class_name Player
extends CharacterBody2D

enum ControlScheme {
	CPU,
	P1,
	P2
}

enum State {
	MOVING,
	TACKLING,
	RECOVERING
}

@export var control_scheme: ControlScheme
@export var speed: float = 80.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

var facing := Vector2.RIGHT
var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()


func _ready() -> void:
	switch_state(State.MOVING)


func _process(_delta: float) -> void:
	set_facing()
	flip_sprites()
	
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	
func switch_state(state: State) -> void:
	if current_state != null:
		remove_child(current_state)
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", Player.State.keys()[state])
	
	call_deferred("add_child", current_state)
		
		
func set_facing() -> void:
	if velocity.x > 0:
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		facing = Vector2.LEFT
		
		
func flip_sprites() -> void:
	if facing == Vector2.RIGHT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	

func update_animation(anim_name: String) -> void:
	assert(animation_player.has_animation(anim_name), str("No animation named %s for Player", [anim_name]))
	animation_player.play(anim_name)
		
