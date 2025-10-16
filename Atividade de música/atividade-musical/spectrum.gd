extends Node

@export var bus_index := 0
@export var effect_index := 0

var analyzer: AudioEffectSpectrumAnalyzerInstance

func _ready():
	analyzer = AudioServer.get_bus_effect_instance(bus_index, effect_index)

func get_bands():
	if not analyzer:
		return [0.0, 0.0, 0.0]
	return [
		analyzer.get_magnitude_for_frequency_range(20, 250).x,     # low
		analyzer.get_magnitude_for_frequency_range(251, 2000).x,   # mid
		analyzer.get_magnitude_for_frequency_range(2001, 16000).x  # high
	]
