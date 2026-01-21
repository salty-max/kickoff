class_name BallStateData
extends RefCounted

var carrier: Player


static func build() -> BallStateData:
	return BallStateData.new()
	
	
func set_carrier(player: Player) -> BallStateData:
	carrier = player
	return self
