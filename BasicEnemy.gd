extends KinematicBody2D

export var attack_power = 1
export var health = 1
export var speed = 200

export var score_value = 100

signal enemy_death(score)

func _process(delta):
	position.x -= speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func take_damage(damage):
	health -= damage
	if health <= 0:
		emit_signal("enemy_death", score_value)
		$CollisionShape2D.set_deferred("disabled", true)
		$Hitbox/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.set_deferred("animation", "Death")
		$DeathTimer.start()
		$DeathSFX.play()
		yield($DeathTimer, "timeout")
		queue_free()


func _on_Hitbox_body_entered(body):
	if body.is_in_group("player_projectile"):
		body._on_hit_Enemy()
		take_damage(body.attack_power)
		
