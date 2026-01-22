class_name BallStateData
extends RefCounted

var carrier: Player
var shot_height: float


static func build() -> BallStateData:
	return BallStateData.new()
	
	
func set_carrier(player: Player) -> BallStateData:
	carrier = player
	return self
	
	
func set_shot_height(_height: float) -> BallStateData:
	shot_height = _height
	return self
