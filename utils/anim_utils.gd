extends Node

enum PlayerAnim {
	BICYCLE,
	CELEBRATE,
	CHEST_CONTROL,
	DIVE_DOWN,
	DIVE_UP,
	IDLE,
	HEADER,
	HURT,
	KICK,
	MOURN,
	PREP_KICK,
	RECOVER,
	RUN,
	TACKLE,
	VOLLEY,
	WALK,
}

const PLAYER_ANIMS_MAP: Dictionary = {
	PlayerAnim.BICYCLE: "bicycle_kick",
	PlayerAnim.CELEBRATE: "celebrate",
	PlayerAnim.CHEST_CONTROL: "chest_control",
	PlayerAnim.DIVE_DOWN: "dive_down",
	PlayerAnim.DIVE_UP: "dive_up",
	PlayerAnim.HEADER: "header",
	PlayerAnim.HURT: "hurt",
	PlayerAnim.IDLE: "idle",
	PlayerAnim.KICK: "kick",
	PlayerAnim.MOURN: "mourn",
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
