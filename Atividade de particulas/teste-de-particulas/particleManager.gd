extends Node3D

@export var modos := ["gravidade", "rotacao", "aceleracao", "espalhamento", "resistencia"]
var modo_atual := 0

func _ready():
	aplicar_modo(modos[modo_atual])

func proximo_modo():
	modo_atual = (modo_atual + 1) % modos.size()
	aplicar_modo(modos[modo_atual])

func configurar_emissor(emitter: GPUParticles3D, quantidade: int, escala_min: float, escala_max: float):
	var material = emitter.process_material
	if material == null:
		material = ParticleProcessMaterial.new()
		emitter.process_material = material

	emitter.amount = quantidade
	material.scale_min = escala_min
	material.scale_max = escala_max

	# Garante que partículas sempre se movem
	if material.initial_velocity_min == 0.0 and material.initial_velocity_max == 0.0:
		material.initial_velocity_min = 10.0
		material.initial_velocity_max = 20.0
		material.direction = Vector3.UP

func aplicar_modo(modo: String):
	match modo:
		"gravidade":
			var emitter = $Emitter_Sphere
			configurar_emissor(emitter, 500, 0.1, 0.3)
			var material = emitter.process_material as ParticleProcessMaterial
			material.gravity = Vector3(0, -9.8, 0)
			emitter.lifetime = 4.0
			emitter.emitting = true

		"rotacao":
			var emitter = $Emitter_Point
			configurar_emissor(emitter, 500, 0.1, 0.3)
			var material = emitter.process_material as ParticleProcessMaterial
			material.angular_velocity_min = 30.0
			material.angular_velocity_max = 60.0
			emitter.lifetime = 3.0
			emitter.emitting = true

		"aceleracao":
			var emitter = $Emitter_Box
			configurar_emissor(emitter, 500, 0.1, 0.3)
			var material = emitter.process_material as ParticleProcessMaterial
			material.initial_velocity_min = 20.0
			material.initial_velocity_max = 50.0
			emitter.lifetime = 3.5
			emitter.emitting = true

		"espalhamento":
			var emitter = $Emitter_Sphere
			configurar_emissor(emitter, 500, 0.1, 0.3)
			var material = emitter.process_material as ParticleProcessMaterial
			material.spread = 180.0
			material.angular_velocity_max = 60.0
			emitter.lifetime = 4.0
			emitter.emitting = true

		"resistencia":
			var emitter = $Emitter_Box
			configurar_emissor(emitter, 500, 0.1, 0.3)
			var material = emitter.process_material as ParticleProcessMaterial
			material.damping_min = 0.0
			material.damping_max = 0.8
			emitter.lifetime = 3.5
			emitter.emitting = true
