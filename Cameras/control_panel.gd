extends CSGBox3D

@export var control_item: ControlItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("Control Panel was entered.")


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Control Panel (body) was entered.")


func use_control_panel() -> void:
	if control_item == null:
		print("Ruh roh! Didn't hook up a control item.")
		return
	control_item.use_item()
