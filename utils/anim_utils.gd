extends Node

enum PlayerAnim {
	BICYCLE,
	CHEST_CONTROL,
	IDLE,
	HEADER,
	KICK,
	PREP_KICK,
	RECOVER,
	RUN,
	TACKLE,
	VOLLEY,
	WALK,
}

const PLAYER_ANIMS_MAP: Dictionary = {
	PlayerAnim.BICYCLE: "bicycle_kick",
	PlayerAnim.CHEST_CONTROL: "chest_control",
	PlayerAnim.HEADER: "header",
	PlayerAnim.IDLE: "idle",
	PlayerAnim.KICK: "kick",
	PlayerAnim.PREP_KICK: "prep_kick",
	PlayerAnim.RECOVER: "recover",
	PlayerAnim.RUN: "run",
	PlayerAnim.TACKLE: "tackle",
	PlayerAnim.VOLLEY: "volley_kick",
	PlayerAnim.WALK: "walk"
}

enum BallAnim {
	IDLE,
	ROLL
} 

const BALL_ANIMS_MAP: Dictionary = {
	BallAnim.IDLE: "idle",
	BallAnim.ROLL: "roll"
}


func get_player_anim(anim: PlayerAnim) -> String:
	return PLAYER_ANIMS_MAP[anim]
	
	
func get_ball_anim(anim: BallAnim) -> String:
	return BALL_ANIMS_MAP[anim]
