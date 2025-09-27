extends Area3D

# เปลี่ยนโค้ดใน EndFlag.gd
func _on_body_entered(body: Node3D):
	# ตรวจสอบว่าโหนดที่ชนอยู่ใน Group "player" หรือไม่
	if body.is_in_group("Player"): 
		# 1. หยุดจับเวลา
		GameManager.timer_active = false
		
		# 2. ไปยังหน้าจบเกม
		# ตรวจสอบให้แน่ใจว่าชื่อไฟล์ GameOver.tscn ถูกต้อง
		get_tree().change_scene_to_file("res://Animated Platformer Character/game_over.tscn")
