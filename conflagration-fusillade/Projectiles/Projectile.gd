extends CharacterBody2D

@export var speed: float = 600.0
@export var damage: float = 10.0
@export var damage_number_scene: PackedScene

var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var displacement := velocity * delta
	var collision := move_and_collide(displacement)
	
	if collision:
		var collider := collision.get_collider()
		if collider is Node:
			var health_component: Node = collider.get_node_or_null("HealthComponent")
			if health_component != null:
				health_component.take_damage(damage)
				spawn_damage_number(collider.global_position)
		
		queue_free()

func spawn_damage_number(target_position: Vector2) -> void:
	if damage_number_scene == null:
		return
	
	var dmg_num := damage_number_scene.instantiate()
	get_tree().current_scene.add_child(dmg_num)
	dmg_num.global_position = target_position + Vector2(0, -35)
	dmg_num.setup(damage)

func _on_lifetime_timeout() -> void:
	queue_free()
