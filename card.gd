extends Node2D

@onready var sprite: Sprite2D = $CardSprite
@onready var shadow_sprite: Sprite2D = $ShadowSprite
@onready var label: Label = $Label
@onready var area_2d: Area2D = $CardSprite/Area2D

@export var card_base_size: float = 1.0
@export var base_card: Texture = preload("res://card_dummy_0.png")

var scale_bigger = self.scale * 1.2
var scale_normal = self.scale * 1.0

var ready_position
var original_rotation: float = 0
var dragging: bool = false

var return_timer: Timer
var return_speed = 0.1

const HOVER_DISTANCE = 20
const HOVER_ANGLE_OFFSET = 90
const TWEEN_DURATION = 0.1

func _ready() -> void:
	setup_shader()
	setup_sprites()
	setup_return_timer()
	connect_signals()

func setup_shader() -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://card_shader.gdshader")
	sprite.material = shader_material

func setup_sprites() -> void:
	sprite.texture = base_card
	shadow_sprite.texture = base_card
	ready_position = Vector2.ZERO
	shadow_sprite.position += Vector2(2, 2)
	shadow_sprite.set_z_index(-1)

func setup_return_timer() -> void:
	return_timer = Timer.new()
	return_timer.wait_time = 1.0
	return_timer.one_shot = true
	add_child(return_timer)
	return_timer.timeout.connect(_on_return_timer_timeout)

func connect_signals() -> void:
	if not area_2d.is_connected("mouse_entered", Callable(self, "_on_area_2d_mouse_entered")):
		area_2d.connect("mouse_entered", Callable(self, "_on_area_2d_mouse_entered"))
	
	if not area_2d.is_connected("mouse_exited", Callable(self, "_on_area_2d_mouse_exited")):
		area_2d.connect("mouse_exited", Callable(self, "_on_area_2d_mouse_exited"))

func _process(delta: float) -> void:
	if dragging:
		global_position = global_position.lerp(get_global_mouse_position(), 30 * delta)
		update_shadow_position()

func update_shadow_position() -> void:
	var viewport_center = get_viewport_rect().size / 2
	var direction_to_center = global_position.direction_to(viewport_center)
	var distance_to_center = global_position.distance_to(viewport_center)
	shadow_sprite.global_position = global_position + direction_to_center * clamp(distance_to_center * 0.1, 3, 10)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			start_dragging()
		elif event.is_released():
			stop_dragging()

func start_dragging() -> void:
	dragging = true
	print("dragging")
	return_timer.stop()
	tween_scale(scale_bigger)
	sprite.modulate = Color.WHITE
	shadow_sprite.modulate = Color.BLACK

func stop_dragging() -> void:
	dragging = false
	print("dropped")
	tween_scale(scale_normal)
	self.rotation_degrees = original_rotation
	return_timer.start()
	shadow_sprite.modulate = Color.TRANSPARENT

func tween_scale(target_scale: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", target_scale, TWEEN_DURATION).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _on_return_timer_timeout() -> void:
	if not dragging:
		var return_tween = create_tween()
		return_tween.tween_property(self, "position", ready_position, return_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).finished.connect(_on_return_tween_finished)

func _on_return_tween_finished() -> void:
	sprite.modulate = Color.FLORAL_WHITE
	shadow_sprite.modulate = Color.TRANSPARENT

func _on_card_view_gui_input(event, tween, card_view):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tween.interpolate_property(card_view, "rect_scale", Vector2(1, 1), Vector2(0.8, 0.8), TWEEN_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.interpolate_property(card_view, "rect_scale", Vector2(1, 1), Vector2(0.97, 0.97), TWEEN_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, TWEEN_DURATION)
		tween.start()

func _on_area_2d_mouse_entered():
	if not dragging:
		print("Mouse entered")
		tween_hover(true)
		sprite.material.set_shader_parameter("is_hovered", true)

func _on_area_2d_mouse_exited():
	if not dragging:
		print("Mouse exited")
		tween_hover(false)
		sprite.material.set_shader_parameter("is_hovered", false)

func tween_hover(hover: bool) -> void:
	var tween = create_tween()
	var target_scale = scale_bigger if hover else scale_normal
	tween.tween_property(self, "scale", target_scale, TWEEN_DURATION).set_trans(Tween.TRANS_BOUNCE)

	var angle_rad = deg_to_rad(original_rotation - HOVER_ANGLE_OFFSET)
	var direction = Vector2(cos(angle_rad), sin(angle_rad))
	var target_position = ready_position + direction * HOVER_DISTANCE if hover else ready_position
	tween.tween_property(self, "position", target_position, TWEEN_DURATION)
