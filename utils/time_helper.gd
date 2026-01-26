class_name TimeHelper

static func get_time_text(time_left: float) -> String:
	var time: float = time_left / 1000.0
	if time < 0:
		return "OVERTIME!"
	else:
		var minutes := int(time / 60.0)
		var seconds := time - minutes * 60
		return "%02d : %02d" % [minutes, seconds]
