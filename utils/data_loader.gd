extends Node

var teams: Dictionary[String, Array]


func _init() -> void:
	var json_file := FileAccess.open("res://assets/json/teams_98.json", FileAccess.READ)
	if not json_file:
		printerr("Could not find or load teams_98.json")
	var json_text := json_file.get_as_text()
	var json := JSON.new()
	
	if json.parse(json_text) != OK:
		printerr("Could not parse teams.json")
	
	for team in json.data:
		var country := team["country"] as String
		var players := team["players"] as Array
		
		if not teams.has(country):
			teams.set(country, [])
			
		for player in players:
			var full_name := player["name"] as String
			var skin_color := player["skin"] as Player.SkinColor
			var role := player["role"] as Player.Role
			var speed := player["speed"] as float
			var power := player["power"] as float
			
			var player_data := PlayerData.new(full_name, skin_color, role, speed, power)
			teams.get(country).append(player_data)
			
		assert(players.size() == 6)
		
	json_file.close()
			

func get_team(country: String) -> Array:
	if teams.has(country):
		return teams[country]
	
	return []
