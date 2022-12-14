extends Node2D

signal goto_room(room)
signal goto_main

var enemy_count := 0
var sleeping_enemies := 0

func _ready():
	var slept='iwenttosleep'
	for enemy in $Enemies.get_children():
		#Only count each enemy once by connecting the signal as "ONESHOT". 
		#	otherwise hitting the same enemy will count towards the total needed to continue.
		enemy.connect("slept", self, '_on_enemy_slept', [], CONNECT_ONESHOT)
		enemy_count += 1

func _on_transition_entered(_body : PhysicsBody2D, room : String):
	#Pass signal through so it can be attached to this node's parent,
	#	And the parent doesn't have to interact with this node's children. 
	emit_signal("goto_room", load(room))

func _on_enemy_slept():
	sleeping_enemies += 1
	if sleeping_enemies >= enemy_count:
		#Once all the madguys are sleeping, open the transition area so we iiican continue upwards
		$TransitionAreas/BarrierUp/CollisionShape2D.set_deferred("disabled", true)
		#Show arrow to indicate direction to the player
		$ArrowPlayer.play("blink")
