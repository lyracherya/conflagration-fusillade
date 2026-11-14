extends CharacterBody2D

@export var speed: float = 100.0
var player: Node2D = null

@onready var health_component: Node = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBarAnchor/EnemyHealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health



func _physics_process(_delta: float) -> void:
	
	if player == null:
		
		return
	
	
	var direction := global_position.direction_to(player.global_position)
	
	
	velocity = direction * speed
	
	
	move_and_slide()


func _on_health_component_health_depleted() -> void:
	queue_free()


func _on_health_component_health_changed(current_health: float, _max_health: float) -> void:
	if health_bar != null:
		health_bar.value = current_health
	if animation_player != null:
		animation_player.play("hit_flash")
