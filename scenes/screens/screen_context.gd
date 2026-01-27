class_name ScreenContext
extends RefCounted

var game: Game = null
var screen_data: ScreenData = null


static func build() -> ScreenContext:
	return ScreenContext.new()
	
	
func set_game(_game: Game) -> ScreenContext:
	game = _game
	return self
	
	
func set_screen_data(_screen_data: ScreenData) -> ScreenContext:
	screen_data = _screen_data
	return self
