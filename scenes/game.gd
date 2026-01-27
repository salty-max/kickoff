class_name Game
extends Node

enum ScreenType {
	IN_GAME,
	MAIN_MENU,
	TEAM_SELECTION,
	Tournament,
} 

var current_screen: Screen = null
var screen_factory := ScreenFactory.new()


func _init() -> void:
	switch_screen(Game.ScreenType.MAIN_MENU)


func switch_screen(screen: Game.ScreenType, data: ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_screen(screen)
	var ctx := ScreenContext.build().set_game(self).set_screen_data(data)
	current_screen.setup(ctx)
	current_screen.screen_transition_requested.connect(switch_screen.bind())
	call_deferred("add_child", current_screen)
