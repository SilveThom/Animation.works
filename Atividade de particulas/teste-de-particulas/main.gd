extends Node3D

func _input(event):
	if event.is_action_pressed("ui_accept"):  # tecla Enter por padrão
		$ParticleSystem3D.proximo_modo()
		$CanvasLayer/Label.text = "Modo: " + $ParticleSystem3D.modos[$ParticleSystem3D.modo_atual]
