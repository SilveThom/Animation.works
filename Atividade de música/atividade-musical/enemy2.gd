extends Node2D

@export var spectrum_node: NodePath
@onready var sprite = $Sprite2D
@onready var trail = $Sprite2D/Trail

var velocity = Vector2.ZERO
var spectrum
var trail_points := []
@export var trail_max_length := 20
var texture_state := 1

func _ready():
	spectrum = get_node(spectrum_node)
	# direção oposta ao Enemy1
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * -200.0
	trail.clear_points()
	global_position = Vector2(576, 324)
	set_sprite_texture(1)
	sprite.scale = Vector2(40, 40)
	trail.width = 10.0

func _process(delta):
	if not spectrum:
		return

	var bands = spectrum.get_bands()
	var low = bands[0]
	var mid = bands[1]
	var high = bands[2]
	position += velocity * low * 200.0 * delta
	sprite.modulate = Color(1.0, 1.0 - mid, 1.0 - mid)
	update_trail()
	handle_bounce()
	check_collision_with_other()

func handle_bounce():
	var screen_size = Vector2(1152, 648)
	var pos = global_position
	var sprite_size = sprite.texture.get_size() * sprite.scale * 0.5
	var bounced_x = false
	var bounced_y = false

	if pos.x < sprite_size.x:
		global_position.x = sprite_size.x
		velocity.x = abs(velocity.x)
		bounced_x = true
	elif pos.x > screen_size.x - sprite_size.x:
		global_position.x = screen_size.x - sprite_size.x
		velocity.x = -abs(velocity.x)
		bounced_x = true

	if pos.y < sprite_size.y:
		global_position.y = sprite_size.y
		velocity.y = abs(velocity.y)
		bounced_y = true
	elif pos.y > screen_size.y - sprite_size.y:
		global_position.y = screen_size.y - sprite_size.y
		velocity.y = -abs(velocity.y)
		bounced_y = true

	if bounced_x or bounced_y:
		spawn_explosion()

	if bounced_x and bounced_y:
		texture_state = (texture_state + 1) % 3
		set_sprite_texture(texture_state)


func set_sprite_texture(state: int):
	var size := 1
	if state == 0:
		size = 1
	elif state == 2:
		size = 2
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0.5, 1))  # Azul escuro opaco
	var tex := ImageTexture.create_from_image(img)
	sprite.texture = tex


func update_trail():
	trail_points.insert(0, global_position)
	if trail_points.size() > trail_max_length:
		trail_points.pop_back()
	trail.clear_points()
	for p in trail_points:
		trail.add_point(to_local(p))

func check_collision_with_other():
	var other = get_parent().get_node_or_null("Enemy1")
	if other and other.global_position.distance_to(global_position) < 40:
		spawn_explosion()
		velocity = -velocity

func spawn_explosion():
	var explosion_scene = preload("res://Explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.scale = Vector2(3, 5)
	get_parent().add_child(explosion)
