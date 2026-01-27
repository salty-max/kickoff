class_name Screen
extends Node

signal screen_transition_requested(new_screen: Game.ScreenType, data: ScreenData)

var game: Game = null
var screen_data: ScreenData = null


func setup(ctx: ScreenContext) -> void:
	game = ctx.game
	screen_data = ctx.screen_data
	
	
func transition_to(new_screen: Game.ScreenType, data: ScreenData = ScreenData.new()) -> void:
	screen_transition_requested.emit(new_screen, data)
