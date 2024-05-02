extends Node2D

var path: Path2D
var number_of_cards: int = 5

var angle: float = 22
var angle_from: float
var angle_to: float
var center: Vector2 # center of the arc
var radius: float # radius of the arc

func _ready() -> void:
	path = Path2D.new()
	add_child(path)
	
	var screen_size: Vector2 = get_viewport_rect().size
	center = Vector2(screen_size.x * 0.5, screen_size.y * 3.05)  
	radius = screen_size.y * 2.2
	angle_from = -(angle/2) -90
	angle_to = angle_from + angle
	create_arc_path(center, radius, angle_from, angle_to)
	place_cards_on_arc()

func create_arc_path(center: Vector2, radius: float, angle_from: float, angle_to: float) -> void:
	var curve := Curve2D.new()
	var angle_step := (angle_to - angle_from) / (number_of_cards - 1)
	
	for i in range(number_of_cards):
		var angle_deg: float = angle_from + i * angle_step
		var angle_rad: float = deg_to_rad(angle_deg)
		var x: float = center.x + cos(angle_rad) * radius
		var y: float = center.y + sin(angle_rad) * radius
		var point := Vector2(x, y)
		curve.add_point(point)
	
	path.curve = curve

func place_cards_on_arc() -> void:
	var max_angle_gap = 5 # angle between each cards
	var total_angle_gap = min((number_of_cards - 1) * max_angle_gap, angle_to - angle_from)
	var angle_step = total_angle_gap / max(1, number_of_cards - 1)

	var start_angle = (angle_from + angle_to - total_angle_gap) / 2

	for i in range(number_of_cards):
		var card = preload("res://card.tscn").instantiate()
		var card_label: Label = card.get_node("Label")
		add_child(card)
		card_label.text = str(i+1)

		var angle_deg = start_angle + i * angle_step
		var angle_rad = deg_to_rad(angle_deg)
		var x = center.x + cos(angle_rad) * radius
		var y = center.y + sin(angle_rad) * radius
		var position = Vector2(x, y)
		card.global_position = position
		card.ready_position = position

		var direction = Vector2(cos(angle_rad), sin(angle_rad))
		var angle = rad_to_deg(atan2(direction.y, direction.x))
		card.rotation_degrees = angle + 90
		card.original_rotation = card.rotation_degrees

func _draw() -> void:
	var points := path.curve.get_baked_points()
	draw_polyline(points, Color.RED, 5.0, true)
