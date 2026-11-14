extends CanvasLayer

@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var health_label: Label = $VBoxContainer/Label


func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player != null:
		var health_component: Node = player.get_node_or_null("HealthComponent")
		if health_component != null:
			health_bar.max_value = health_component.max_health
			health_bar.value = health_component.current_health
			health_label.text = "%d / %d" % [int(health_component.current_health), int(health_component.max_health)]

func _on_health_component_health_changed(current_health: float, max_health: float) -> void:
	if not is_node_ready():
		await ready
	
	if health_bar != null:
		health_bar.value = current_health
	if health_label != null:
		health_label.text = "%d / %d" % [int(current_health), int(max_health)]
