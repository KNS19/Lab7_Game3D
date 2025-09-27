extends Control

@onready var coins_label = $CoinsResultLabel
@onready var time_label = $TimeResultLabel
@onready var restart_button = $RestartButton
@onready var start_panel = get_parent().get_node("StartPanel")
@onready var game_ui = get_parent().get_node("GameUI")

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	self.visible = false

func show_game_over():
	self.visible = true
	game_ui.visible = false
	coins_label.text = "Coins: %d" % GameManager.score
	time_label.text = "Time: %s" % format_time(GameManager.elapsed_time)

func _on_restart_pressed():
	GameManager.reset()
	self.visible = false
	start_panel.visible = true

func format_time(seconds: float) -> String:
	var total = int(seconds)
	var s = total % 60
	var m = (total / 60) % 60
	return "%02d:%02d" % [int(m), int(s)]
