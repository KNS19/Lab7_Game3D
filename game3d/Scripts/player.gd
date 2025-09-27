# ----------------------------------------------------------------------------------- #
# -------------- FEEL FREE TO USE IN ANY PROJECT, COMMERCIAL OR NON-COMMERCIAL ------ #
# ---------------------- 3D PLATFORMER CONTROLLER BY SD STUDIOS --------------------- #
# ---------------------------- ATTRIBUTION NOT REQUIRED ----------------------------- #
# ----------------------------------------------------------------------------------- #

extends CharacterBody3D

# ---------- VARIABLES ---------- #

@export_category("Player Properties")
@export var move_speed : float = 6
@export var jump_force : float = 6
@export var follow_lerp_factor : float = 4
@export var jump_limit : int = 2 # Note: This variable isn't used in the current logic.

@export_group("Game Juice")
@export var jumpStretchSize := Vector3(0.8, 1.2, 0.8)

# Booleans
var is_grounded = false
var can_double_jump = false # ตัวแปรสำหรับควบคุมการกระโดดครั้งที่สอง

# Onready Variables
@onready var model = $CharacterArmature
@onready var animation = $CharacterArmature/AnimationPlayer
@onready var spring_arm = %Gimbal

@onready var particle_trail = $ParticleTrail
@onready var footsteps = $Footsteps

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

# ---------- FUNCTIONS ---------- #

func _process(delta):
	player_animations()
	get_input(delta)
	
	# Smoothly follow player's position
	spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)
	
	# Player Rotation
	if is_moving():
		var look_direction = Vector2(velocity.z, velocity.x)
		model.rotation.y = lerp_angle(model.rotation.y, look_direction.angle(), delta * 12)
	
	# Check if player is grounded or not
	is_grounded = is_on_floor()
	
	# Handle Jumping: Reset Double Jump on Ground
	if is_grounded:
		can_double_jump = true # **รีเซ็ตเมื่อสัมผัสพื้น**
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			perform_jump() # กระโดดครั้งแรก
		elif can_double_jump:
			# **ปรับปรุง:** นำเงื่อนไข 'if is_moving():' ออก เพื่อให้ Double Jump ทำงานได้เสมอ
			perform_flip_jump() # กระโดดครั้งที่สอง
			can_double_jump = false # **ปิด Double Jump ทันที**
	
	velocity.y -= gravity * delta

func perform_jump():
	AudioManager.jump_sfx.play()
	AudioManager.jump_sfx.pitch_scale = 1.12
	
	jumpTween()
	animation.play("CharacterArmature|Jump")
	velocity.y = jump_force

func perform_flip_jump():
	AudioManager.jump_sfx.play()
	AudioManager.jump_sfx.pitch_scale = 0.8
	
	# เล่น Animation สำหรับ Double Jump
	animation.play("CharacterArmature|Duck", -1, 2)
	
	velocity.y = jump_force
	
	# **ปรับปรุง:** ลบ 'await animation.animation_finished' และการตั้งค่า can_double_jump ออก
	# เพราะเราจัดการปิด can_double_jump ใน _process() แล้ว
	await get_tree().create_timer(0.1).timeout # อาจใส่ดีเลย์สั้นๆ เพื่อให้แอนิเมชันเริ่มก่อน
	animation.play("CharacterArmature|Jump", 0.5)

func is_moving():
	return abs(velocity.z) > 0 || abs(velocity.x) > 0

func jumpTween():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", jumpStretchSize, 0.1)
	tween.tween_property(self, "scale", Vector3(1,1,1), 0.1)

# Get Player Input
func get_input(_delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")
	
	# Move The player Towards Spring Arm/Camera Rotation
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	velocity = Vector3(move_direction.x * move_speed, velocity.y, move_direction.z * move_speed)

	move_and_slide()

# Handle Player Animations
func player_animations():
	particle_trail.emitting = false
	footsteps.stream_paused = true
	
	if is_on_floor():
		if is_moving(): # Checks if player is moving
			animation.play("CharacterArmature|Run", 0.5)
			particle_trail.emitting = true
			footsteps.stream_paused = false
		else:
			animation.play("CharacterArmature|Idle", 0.5)
