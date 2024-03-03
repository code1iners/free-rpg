extends CharacterBody2D

var enemy_inataack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

const SPEED = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	
	if health <= 0:
		player_alive = false # go back to menu or respond
		health = 0
		print("player has been killed")
		self.queue_free()
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -SPEED
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = SPEED
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
				
	move_and_slide()
	
func play_anim(status):
	var dir = current_dir
	var anim: AnimatedSprite2D = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if status == 1:
			anim.play("side_walk")	
		elif status == 0:
			if attack_ip == false:
				anim.play("side_idle")	
		
	if dir == "left":
		anim.flip_h = true
		if status == 1:
			anim.play("side_walk")
		elif status == 0:
			if attack_ip == false:
				anim.play("side_idle")
				
	if dir == "up":
		if status == 1:
			anim.play("back_walk")
		elif status == 0:
			if attack_ip == false:
				anim.play("back_idle")
				
	if dir == "down":
		if status == 1:
			anim.play("front_walk")
		elif status == 0:
			if attack_ip == false:
				anim.play("front_idle")
			

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inataack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inataack_range = false

func enemy_attack():
	if enemy_inataack_range and enemy_attack_cooldown == true:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	
func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliff_side_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliff_side_camera.enabled = true
