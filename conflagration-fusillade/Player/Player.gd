extends CharacterBody2D

@export var speed: float = 250.0
@export var projectile_scene: PackedScene

@onready var aim_pivot: Node2D = $AimPivot
@onready var muzzle: Marker2D = $AimPivot/Muzzle
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_interactable: Area2D = null

var is_defeated: bool = false

func _physics_process(_delta: float) -> void:
	if is_defeated:
		return
	
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.0)
	velocity = input_direction * speed
	move_and_slide()

func _process(_delta: float) -> void:
	if is_defeated:
		return
	
	aim_pivot.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire_primary"):
		shoot()
	
	if Input.is_action_just_pressed("debug_player_damage"):
		health_component.take_damage(10.0)
	
	# 1. Check whether interact (E) was pressed
	if Input.is_action_just_pressed("interact"):
		# 2. Check if an interactable is nearby and call its function
		if current_interactable != null and current_interactable.has_method("interact"):
			current_interactable.interact()

func shoot() -> void:
	var projectile := projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = muzzle.global_position
	projectile.direction = (get_global_mouse_position() - muzzle.global_position).normalized()


func _on_health_component_health_depleted() -> void:
	is_defeated = true
	velocity = Vector2.ZERO
	
	
	modulate = Color(0.5, 0.5, 0.5, 0.6)


func _on_health_component_health_changed(current_health: float, max_health: float) -> void:
	if animation_player != null:
		animation_player.stop()
		animation_player.play("animations/hit_flash")
		
		
func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		current_interactable = area

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area == current_interactable:
		current_interactable = null
