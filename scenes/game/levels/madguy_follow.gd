extends PathFollow2D

export var follow_speed := 1

#Remote transform lets us move the enemy without having to put them somewhere obscure in the scene tree.
#Since we need to do some processing on the enemy in the level's _ready() function, 
#	it's better to have them all grouped under one node than to have them as children of the path follow.
var target : KinematicBody2D
var go := true

func _ready():
	#TODO: No good, this is relative to the remotetransform, not to this node. duh
	target = $RemoteTransform2D.get_node($RemoteTransform2D.remote_path)
	if target != null:
		target.connect("slept", self, "stop")

#This will be triggered when the target enemy goes to sleep so they stop moving.
func stop():
	go = false

func _physics_process(_delta):
	if go:
		set_offset(get_offset() + follow_speed)
