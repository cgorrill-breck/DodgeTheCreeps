class_name World
extends Node2D
@export var mob_scene : PackedScene
@onready var mob_spawn_timer = $MobSpawnTimer
@onready var start_timer = $StartTimer

func _enter_tree():
	MainInstances.world = self
	
func _ready():
	start_level()
	
func start_level():
	start_timer.start()

func spawn_mob():
	var spawner = get_tree().get_nodes_in_group("spawn_points").pick_random()
	var mob = mob_scene.instantiate()
	var mob_spawn_location = spawner.position
	mob.position = mob_spawn_location
	add_child(mob)
	
func _on_mob_spawn_timer_timeout():
	print("mob timeout")
	spawn_mob()
	mob_spawn_timer.start()
	

func _on_start_timer_timeout():
	print("Start timeout")
	mob_spawn_timer.start()
