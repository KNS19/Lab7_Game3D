extends Control

@onready var coinsLabel = $CoinsLabel
@onready var timeLabel = $TimeLabel

var elapsed_time: float = 0.0
var timer_running: bool = false

func _ready() -> void:
	timeLabel.text = "00:00"
	start_timer()  # เริ่มนับทันที ถ้าไม่อยากให้เริ่มทันที ให้ลบบรรทัดนี้

func _process(delta: float) -> void:
	# update coin
	coinsLabel.text = "x %d" % GameManager.total_coins

	# update timer
	if timer_running:
		elapsed_time += delta
		timeLabel.text = format_time(elapsed_time)

func format_time(seconds: float) -> String:
	var total = int(seconds)
	var s = total % 60
	var m = (total / 60) % 60
	var h = total / 3600
	if int(h) > 0:
		return "%02d:%02d:%02d" % [int(h), int(m), int(s)]
	return "%02d:%02d" % [int(m), int(s)]

# ควบคุม timer
func start_timer() -> void:
	timer_running = true

func pause_timer() -> void:
	timer_running = false

func reset_timer() -> void:
	elapsed_time = 0.0
	timeLabel.text = "00:00"
	timer_running = false
