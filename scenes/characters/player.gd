class_name Player
extends CharacterBody2D

enum ControlScheme {
	CPU,
	P1,
	P2
}

@export var control_scheme: ControlScheme
@export var speed: float = 80.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite

var facing := Vector2.RIGHT


func _process(_delta: float) -> void:
	if control_scheme == ControlScheme.CPU:
		pass
	else:
		handle_input()
		
	set_movement_animation()
	set_facing()
	flip_sprite()
	
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	
func handle_input() -> void:
	var direction := KeyUtils.get_input_vector(control_scheme)
	velocity = direction * speed
	
	
func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")
		
		
func set_facing() -> void:
	if velocity.x > 0:
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		facing = Vector2.LEFT
		
		
func flip_sprite() -> void:
	if facing == Vector2.RIGHT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
