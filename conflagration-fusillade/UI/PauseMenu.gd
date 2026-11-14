extends CanvasLayer

@onready var resume_button: Button = $PanelContainer/VBoxContainer/Resume
@onready var quit_button: Button = $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	# Ensure PauseMenu stays interactive while paused and starts hidden
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	
	# Connect to GameManager's state_changed signal and button presses
	GameManager.state_changed.connect(_on_game_state_changed)
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_game_state_changed(new_state: GameManager.State) -> void:
	if new_state == GameManager.State.PAUSED:
		show()
	elif new_state == GameManager.State.PLAYING:
		hide()

func _on_resume_pressed() -> void:
	GameManager.change_state(GameManager.State.PLAYING)

func _on_quit_pressed() -> void:
	# Unpause first in case you switch to a main menu later, then quit the app
	get_tree().paused = false
	get_tree().quit()
