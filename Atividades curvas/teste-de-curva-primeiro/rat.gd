extends Node3D

@export var speed: float = 3.0

var curve := Curve3D.new()
var distance_traveled := 0.0
var going_forward := true # controla se está indo ou voltando

func _ready():
	var waypoints = get_node("../Waypoints").get_children()

	# Adiciona as posições dos Marker3D à curva
	for point in waypoints:
		curve.add_point(point.global_position)
	
	# Não fecha o loop — queremos ida e volta, não reinício imediato
	# curve.add_point(waypoints[0].global_position) ← Removido

	curve.bake_interval = 0.1

func _process(delta):
	if curve.get_point_count() < 2:
		return
	
	var curve_length = curve.get_baked_length()
	
	# Atualiza a distância com base na direção
	if going_forward:
		distance_traveled += speed * delta
		if distance_traveled >= curve_length:
			distance_traveled = curve_length
			going_forward = false
	else:
		distance_traveled -= speed * delta
		if distance_traveled <= 0.0:
			distance_traveled = 0.0
			going_forward = true
	
	# Interpola posição na curva
	var pos = curve.sample_baked(distance_traveled)
	global_position = pos

	# Gira o personagem para olhar na direção do movimento
	var offset = 1.0 if going_forward else -1.0
	var next_pos = curve.sample_baked(clamp(distance_traveled + offset, 0.0, curve_length))
	look_at(next_pos, Vector3.UP)
