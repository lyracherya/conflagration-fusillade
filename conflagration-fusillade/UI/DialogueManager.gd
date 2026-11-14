extends CanvasLayer

@onready var speaker_label: Label = $PanelContainer/VBoxContainer/SpeakerName
@onready var dialogue_text: RichTextLabel = $PanelContainer/VBoxContainer/DialogueText
@onready var continue_prompt: Label = $PanelContainer/VBoxContainer/ContinuePrompt

var lines: Array[String] = []
var current_index: int = 0
var is_active: bool = false

func _ready() -> void:
	hide()

func start_dialogue(speaker: String, dialogue_lines: Array[String]) -> void:
	if dialogue_lines.is_empty():
		return
	
	lines = dialogue_lines
	current_index = 0
	is_active = true
	
	
	GameManager.change_state(GameManager.State.DIALOGUE)
	
	speaker_label.text = speaker
	continue_prompt.text = "Press E to continue..."
	show()
	
	set_player_movement(false)
	display_current_line()

func display_current_line() -> void:
	dialogue_text.text = lines[current_index]

func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		advance_dialogue()

func advance_dialogue() -> void:
	current_index += 1
	
	if current_index < lines.size():
		display_current_line()
	else:
		end_dialogue()

func end_dialogue() -> void:
	is_active = false
	lines.clear()
	current_index = 0
	hide()
	
	set_player_movement(true)
	
	
	GameManager.change_state(GameManager.State.PLAYING)

func set_player_movement(can_move: bool) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		player.set_physics_process(can_move)
		player.set_process(can_move)
		if not can_move:
			player.velocity = Vector2.ZERO
