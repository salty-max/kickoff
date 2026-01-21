extends Node

enum PlayerAnim {
	IDLE,
	KICK,
	PREP_KICK,
	RECOVER,
	RUN,
	TACKLE,
}

const PLAYER_ANIMS_MAP: Dictionary = {
	PlayerAnim.IDLE: "idle",
	PlayerAnim.KICK: "kick",
	PlayerAnim.PREP_KICK: "prep_kick",
	PlayerAnim.RECOVER: "recover",
	PlayerAnim.RUN: "run",
	PlayerAnim.TACKLE: "tackle",
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
