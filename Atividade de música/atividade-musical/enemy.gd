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
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 200.0
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

func handle_bounce():
	var screen_size = Vector2(1152, 648)
	var pos = global_position
	var sprite_size = sprite.texture.get_size() * sprite.scale * 0.5
	var bounced_x = false
	var bounced_y = false

	# Verifica colisão nas bordas X
	if pos.x < sprite_size.x:
		global_position.x = sprite_size.x  # Corrige posição
		velocity.x = abs(velocity.x)       # Garante movimento para a direita
		bounced_x = true
	elif pos.x > screen_size.x - sprite_size.x:
		global_position.x = screen_size.x - sprite_size.x
		velocity.x = -abs(velocity.x)      # Garante movimento para a esquerda
		bounced_x = true

	# Verifica colisão nas bordas Y
	if pos.y < sprite_size.y:
		global_position.y = sprite_size.y
		velocity.y = abs(velocity.y)       # Garante movimento para baixo
		bounced_y = true
	elif pos.y > screen_size.y - sprite_size.y:
		global_position.y = screen_size.y - sprite_size.y
		velocity.y = -abs(velocity.y)      # Garante movimento para cima
		bounced_y = true

	# Se colidiu em qualquer direção, trata a explosão
	if bounced_x or bounced_y:
		spawn_explosion()

	# Se bateu em uma quina, muda textura
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
	img.fill(Color(0, 1, 0, 1))
	var tex := ImageTexture.create_from_image(img)
	sprite.texture = tex

func update_trail():
	trail_points.insert(0, global_position)
	if trail_points.size() > trail_max_length:
		trail_points.pop_back()
	trail.clear_points()
	for p in trail_points:
		trail.add_point(to_local(p))

func spawn_explosion():
	var explosion_scene = preload("res://Explosion.tscn")
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.scale = Vector2(3, 5)
	get_parent().add_child(explosion)
