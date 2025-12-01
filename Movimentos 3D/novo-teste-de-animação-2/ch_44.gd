extends Node3D

# Referência ao AnimationTree
@onready var animation_tree: AnimationTree = $AnimationTree
# Playback da State Machine
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

func _ready() -> void:
	# Ativa o AnimationTree
	animation_tree.active = true
	# Começa com Idle
	state_machine.start("Animations_Idle")

func _input(event: InputEvent) -> void:
	# Usando apenas Input.is_action_pressed para manter a animação enquanto tecla está pressionada
	if Input.is_action_pressed("ui_left"):
		state_machine.travel("Animations_Breakdance")
	elif Input.is_action_pressed("ui_right"):
		state_machine.travel("Animations_Breakdance 2")
	elif Input.is_action_pressed("ui_down"):
		state_machine.travel("Animations_Defeat")
	else:
		# Volta para Idle se nenhuma tecla estiver pressionada
		state_machine.travel("Animations_Idle")
