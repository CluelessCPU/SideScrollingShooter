extends Area2D

var screen_size = Vector2.ZERO

export var speed = 200
export var base_health = 3
export var attack_power = 1
export (PackedScene) var bullet_scene

var health = 0.001

export var can_shoot = true

signal health(new_health)
signal player_death()

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	position += direction * speed * delta
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if Input.is_action_pressed("shoot") && can_shoot:
		var bullet = bullet_scene.instance()
		$"..".add_child(bullet)
		
		bullet.position = position
		
		$ShootSFX.play()
		
		can_shoot = false
		$PrimaryCooldown.start()
	
	if Input.is_action_pressed("abandon"):
		kill_player()

func startup():
	show()
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite.set_deferred("animation", "Flying")
	health = base_health
	emit_signal("health", health)
	can_shoot = true


func take_damage(damage_value):
	health -= damage_value
	emit_signal("health", health)
	$DamageSFX.play()
	
	if health <= 0:
		kill_player()
		return
	
	$AnimatedSprite.set_deferred("animation", "Hurt")
	$CollisionShape2D.set_deferred("disabled", true)
	$DamageTimer.start()
	yield($DamageTimer, "timeout")
	$AnimatedSprite.set_deferred("animation", "Flying")
	$CollisionShape2D.set_deferred("disabled", false)
	

func kill_player():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.set_deferred("animation", "Death")
	can_shoot = false
	$DeathSFX.play()
	emit_signal("player_death")
	$DamageTimer.start()
	yield($DamageTimer, "timeout")
	hide()
	
	
func _on_Player_body_entered(body):
	if body.is_in_group("enemy"):
		print("collision!")
		take_damage(body.attack_power)
		body.take_damage(self.attack_power)

func _on_PrimaryCooldown_timeout():
	if health > 0:
		can_shoot = true
