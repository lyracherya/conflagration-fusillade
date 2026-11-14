extends Area2D

@export var next_level: PackedScene
@export var required_encounters: int = 2

var cleared_encounters: int = 0
var is_unlocked: bool = false

func _ready() -> void:
	is_unlocked = false
	cleared_encounters = 0
	hide()
	monitoring = false

# Connected from EVERY Encounter's encounter_completed signal
func unlock() -> void:
	cleared_encounters += 1
	print("Encounters cleared: %d / %d" % [cleared_encounters, required_encounters])
	
	# Only open the exit once ALL required encounters are finished
	if cleared_encounters >= required_encounters and not is_unlocked:
		is_unlocked = true
		show()
		set_deferred("monitoring", true)
		print("All encounters cleared! LevelExit unlocked!")

func _on_body_entered(body: Node2D) -> void:
	if not is_unlocked:
		return
	
	if not body.is_in_group("player"):
		return
	
	if next_level == null:
		push_warning("LevelExit: next_level is not assigned in the Inspector!")
		return
	
	GameManager.change_state(GameManager.State.PLAYING)
	get_tree().call_deferred("change_scene_to_packed", next_level)
