extends Node2D

# Step 6: Signal emitted when all spawned enemies are defeated
signal encounter_completed

# Step 4: Required variables
@export var enemy_scene: PackedScene

@export var is_boss_encounter: bool = false
@export var boss_name: String = "THE INFESTATION"
@export var boss_hud: CanvasLayer

var started: bool = false
var remaining_enemies: int = 0
var completed: bool = false
var active_enemies: Array[Node] = []

@onready var trigger: Area2D = $Trigger
@onready var spawn_points: Node2D = $SpawnPoints

# Step 2: Connected from Trigger (Area2D)'s body_entered signal
func _on_trigger_body_entered(body: Node2D) -> void:
	# Only the player should activate the encounter
	if not body.is_in_group("player"):
		return
	
	# Step 5.1: Check that the encounter hasn't already started
	if started:
		return
	
	start_encounter()

# Step 5: Enemy spawning logic
func start_encounter() -> void:
	# 2. Set started to true
	started = true
	
	# 3. Disable the trigger safely so it cannot activate again
	trigger.set_deferred("monitoring", false)
	
	# 4. Get all children of SpawnPoints
	var markers := spawn_points.get_children()
	
	# 5. For each spawn marker, spawn and track an enemy
	for marker in markers:
		if enemy_scene == null:
			push_warning("Encounter: enemy_scene is not assigned in the Inspector!")
			return
		
		var enemy := enemy_scene.instantiate()
		get_tree().current_scene.add_child(enemy)
		enemy.global_position = marker.global_position
		if is_boss_encounter and boss_hud != null:
			var health_component: Node = enemy.get_node_or_null("HealthComponent")
			if health_component != null:
				boss_hud.show_boss(boss_name, health_component.current_health, health_component.max_health)
				health_component.health_changed.connect(boss_hud.update_health)
				health_component.health_depleted.connect(boss_hud.hide_boss)
		
		# Track the enemy and increase remaining_enemies
		active_enemies.append(enemy)
		remaining_enemies += 1
		
		# Step 6.1: Connect tree_exited signal, binding this specific enemy
		enemy.tree_exited.connect(_on_enemy_exited.bind(enemy))

# Step 6: Encounter completion logic
func _on_enemy_exited(enemy: Node) -> void:
	# Guard against scene reloads/exits when closing the game
	if completed or not is_inside_tree():
		return
	
	# 3. Remove from active-enemy tracking collection
	active_enemies.erase(enemy)
	
	# 4. Decrease remaining_enemies
	remaining_enemies -= 1
	
	# 5. Check whether remaining_enemies has reached zero
	if remaining_enemies <= 0 and not completed:
		completed = true
		encounter_completed.emit()
		print("ENCOUNTER CLEARED")
