extends CanvasLayer

@onready var boss_panel: PanelContainer = $Layout/BossPanel
@onready var boss_name_label: Label = $Layout/BossPanel/VBoxContainer/HBoxContainer/BossName
@onready var health_text_label: Label = $Layout/BossPanel/VBoxContainer/HBoxContainer/HealthText
@onready var health_bar: ProgressBar = $Layout/BossPanel/VBoxContainer/HealthBar

func _ready() -> void:
	boss_panel.hide()

func show_boss(boss_title: String, current_health: float, max_health: float) -> void:
	boss_name_label.text = boss_title
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_text_label.text = "%d / %d" % [int(current_health), int(max_health)]
	boss_panel.show()

func update_health(current_health: float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_text_label.text = "%d / %d" % [int(current_health), int(max_health)]

func hide_boss() -> void:
	boss_panel.hide()
