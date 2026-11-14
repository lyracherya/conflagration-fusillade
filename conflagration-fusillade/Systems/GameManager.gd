extends Node

enum State {
	PLAYING,
	DIALOGUE,
	PAUSED,
	DEFEATED,
	VICTORY
}

signal state_changed(new_state: State)

var current_state: State = State.PLAYING

func _ready() -> void:
	# Ensure GameManager continues receiving input while get_tree().paused is true
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if current_state == State.PLAYING:
			change_state(State.PAUSED)
		elif current_state == State.PAUSED:
			change_state(State.PLAYING)
		# DIALOGUE, DEFEATED, and VICTORY are intentionally ignored

func change_state(new_state: State) -> void:
	current_state = new_state
	get_tree().paused = (new_state == State.PAUSED)
	state_changed.emit(new_state)
