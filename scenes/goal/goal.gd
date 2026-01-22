class_name Goal
extends Node2D

@onready var back_net_area: Area2D = $BackNetArea


func _ready() -> void:
	back_net_area.body_entered.connect(_on_ball_entered)
	
	
func _on_ball_entered(ball: Ball) -> void:
	ball.stop()
	
