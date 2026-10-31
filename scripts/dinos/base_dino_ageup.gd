class_name BaseDinoAgeup
extends Node

# Returns a Dictionary keyed by life_stage (1=Juvenile, 2=Sub-adult, 3=Adult, 4=Elder).
# Each entry: { "stage_label", "title", "body", "choices": [{ "label", "best" }] }
func get_ageups() -> Dictionary:
	return {}

func get_ageup(stage: int) -> Dictionary:
	return get_ageups().get(stage, {})
