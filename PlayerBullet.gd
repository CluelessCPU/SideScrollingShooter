extends KinematicBody2D


export var speed = 300
export var attack_power = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += delta * speed
	
func _on_hit_Enemy():
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
