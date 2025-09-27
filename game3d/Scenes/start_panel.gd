extends Control

@onready var start_button = $StartButton
@onready var game_ui = get_parent().get_node("GameUI")
@onready var game_over_panel = get_parent().get_node("GameOverPanel")

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	self.visible = true               # Show Start Panel
	game_ui.visible = false            # Hide Game UI
	game_over_panel.visible = false    # Hide Game Over

func _on_start_pressed():
	GameManager.reset()
	GameManager.game_running = true
	self.visible = false
	game_ui.visible = true
