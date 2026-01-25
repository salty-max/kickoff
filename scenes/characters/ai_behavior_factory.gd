class_name AIBehaviorFactory

var roles: Dictionary


func _init() -> void:
	roles = {
		Player.Role.GOALKEEPER: AIBehaviorGoalkeeper,
		Player.Role.DEFENSER: AIBehaviorField,
		Player.Role.MIDFIELDER: AIBehaviorField,
		Player.Role.FORWARD: AIBehaviorField
	}
	
	
func get_ai_behavior(role: Player.Role) -> AIBehavior:
	assert(roles.has(role), "role doesn't have an associated AI behavior")
	return roles.get(role).new()
