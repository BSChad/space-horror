class_name Player
extends RigidBody3D


@export var move_speed = 0.75
@export var steer_speed = 0.005
@export var launch_speed = 1.5
@export var mouse_sensitivity := 700
@export var gamepad_sensitivity := 0.075

@onready var camera = $Camera3D

var _launched := false
var _attached_surface: GeometryInstance3D = null
var _attachment_point: Vector3 = Vector3.ZERO
var _input_mouse: Vector2
var _rotation_target: Vector3

var _use_target: Node3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Mouse movement
func _input(event):
	if event is InputEventMouseMotion:
		_input_mouse = event.relative / mouse_sensitivity
		_rotation_target.y -= event.relative.x / mouse_sensitivity
		_rotation_target.x -= event.relative.y / mouse_sensitivity


func _physics_process(delta: float) -> void:
	# Camera Rotation
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	_rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	_rotation_target.x = clamp(_rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	
	camera.rotation.z = lerp_angle(camera.rotation.z, -_input_mouse.x * 25 * delta, delta * 5)
	camera.rotation.x = lerp_angle(camera.rotation.x, _rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, _rotation_target.y, delta * 25)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and not _launched:
		_launched = true
		var launch_direction = camera.global_basis * Vector3.FORWARD
		linear_velocity = launch_direction * launch_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var localized_dir = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	var direction = localized_dir.normalized()
	if _launched:
		if direction:
			linear_velocity.x = move_toward(linear_velocity.x, direction.x, steer_speed)
			linear_velocity.z = move_toward(linear_velocity.z, direction.z, steer_speed)
	else:
		if direction:
			linear_velocity.x = direction.x * move_speed
			linear_velocity.z = direction.z * move_speed
		else:
			linear_velocity.x = move_toward(linear_velocity.x, 0, move_speed)
			linear_velocity.z = move_toward(linear_velocity.z, 0, move_speed)

	var collision := move_and_collide(linear_velocity)
	if collision != null:
		_launched = false
	
	if _use_target != null and Input.is_action_just_pressed("interact"):
		_use_target.use_control_panel()


func is_attached_to_surface() -> bool:
	return _attached_surface != null


func _on_body_entered(body: Node) -> void:
	print("Collided with something!")


func _on_use_target_area_3d_area_entered(area: Area3D) -> void:
	print("Player found something!")
	_use_target = area.get_parent_node_3d()


func _on_use_target_area_3d_area_exited(area: Area3D) -> void:
	print("Player left thing!")
	if _use_target == area.get_parent_node_3d():
		_use_target = null
