class_name TimedDoorControlItem
extends DoorControlItem

@export var open_time := 5.0
var close_timer := 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if close_timer > 0.0:
		close_timer -= delta
		
		if close_timer <= 0.0:
			close_door()


func use_item() -> void:
	open_door()
	close_timer = open_time
