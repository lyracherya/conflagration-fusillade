extends Area2D

@export var speaker_name: String = "Survivor"
@export_multiline var dialogue_lines: Array[String] = [
	"Hey! Watch out for the zombies outside.",
	"Grab whatever supplies you can find."
]

func interact() -> void:
	DialogueManager.start_dialogue(speaker_name, dialogue_lines)
