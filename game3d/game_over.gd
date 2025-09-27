extends Control

# 🟢 แก้ไข: ใส่ Path ที่ถูกต้องตามโครงสร้าง Scene ของคุณ เช่น $VBoxContainer/CoinsLabel
@onready var coins_label = $CoinsLabel 
@onready var time_label = $TimeLabel 

func _ready():
	# 1. หยุดจับเวลา
	GameManager.timer_active = false
	
	# 2. แสดงผลลัพธ์ (Coins)
	# ✅ ตรวจสอบว่าโหนดถูกค้นพบ (ป้องกัน Null Error ซ้ำ)
	if is_instance_valid(coins_label): 
		coins_label.text = "Coins Collected: %d" % GameManager.total_coins
	
	# 3. คำนวณเวลา
	var time_in_seconds = GameManager.total_time
	var minutes = int(time_in_seconds) / 60
	var seconds = fmod(time_in_seconds, 60.0)
	
	# 4. แสดงผลลัพธ์ (Time)
	if is_instance_valid(time_label):
		time_label.text = "Time Used: %02d:%05.2f" % [minutes, seconds]
	
	# 5. แสดงเมาส์
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_again_button_pressed(): # ต้องเชื่อมต่อ Signal ของปุ่ม Play Again
	# กลับไปหน้าเริ่มต้น
	get_tree().change_scene_to_file("res://Scenes/demo_scene.tscn")
	
	
func _on_button_2_pressed() -> void:
	get_tree().quit() 
