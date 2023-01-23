extends Node

export (PackedScene) var enemy_scene


var score = 0

signal update_score(score)
signal game_over()



func _on_HUD_start_level():
	score = 0
	emit_signal("update_score", score)
	$Player.position = $PlayerSpawn.position
	$Player.startup()

	$SpawnTimer.start()
	
	$ParallaxBackground/StarLayer.scrolling_start()


func _on_SpawnTimer_timeout():
	var EnemySpawnLocation = $EnemySpawnPath/EnemySpawnLocation
	EnemySpawnLocation.unit_offset = randf()

	var enemy = enemy_scene.instance()
	add_child(enemy)
	
	enemy.position = EnemySpawnLocation.position
	enemy.rotation = 0
	enemy.connect("enemy_death", self, "_on_Enemy_death")
	
func _on_Enemy_death(enemy_score):
	score += enemy_score
	emit_signal("update_score", score)
	


func _on_Player_player_death():
	$SpawnTimer.stop()
	$HUD.game_over()
	$ParallaxBackground/StarLayer.scrolling_stop()
