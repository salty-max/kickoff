class_name BallStateCarried
extends BallState


func _ready() -> void:
	assert(carrier != null, "Ball should have a carrier when entering CARRIED state")
	
	
func _physics_process(_delta: float) -> void:
	ball.position = carrier.position
