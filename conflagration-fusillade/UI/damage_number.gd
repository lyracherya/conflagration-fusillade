extends Node2D

@onready var label: Label = $Label

func setup(damage_amount: float) -> void:
	label.text = str(int(damage_amount))
	
	# Animate moving up 30 pixels and fading out over 0.6 seconds
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", position.y - 30.0, 0.6).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN)
	
	# Delete itself once finished
	tween.chain().tween_callback(queue_free)
