class_name DoorControlItem
extends ControlItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_item() -> void:
	open_door()


func open_door() -> void:
	var door_open_tween := get_tree().create_tween()
	door_open_tween.tween_property(self, "position:y", 10.0, 1.5)
	door_open_tween.play()


func close_door() -> void:
	var door_open_tween := get_tree().create_tween()
	door_open_tween.tween_property(self, "position:y", 0.0, 1.5)
	door_open_tween.play()
