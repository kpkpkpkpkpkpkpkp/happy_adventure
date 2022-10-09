extends Node
var game_world : Node2D

func _on_Game_starting(game_scene : PackedScene):
	ScreenFader.fade_out()
	#Wait until the main menu is done doing its thing, (Playing its sound effect) 
	#	and then instance and start the game.
	yield($Title,"tree_exited")
	
	#Instance the game and start it! 
	#Keep a reference so we can free it later
	game_world = game_scene.instance()
	add_child(game_world)
	
	#Connect a signal ahead of time so that the main scene can handle things when the game ends.
	game_world.connect('end_game', self, 'open_main_menu')
	ScreenFader.fade_in()

func open_main_menu():
	#Fade out of game
	ScreenFader.fade_out()
	yield(ScreenFader, "faded_out")
	game_world.queue_free()
	
	#Fade in to end cutscene
	ScreenFader.fade_in()
	$EndCutscene.visible = true
	yield(ScreenFader, "faded_in")
	
	$EndCutscenePlayer.play("play_end")
	
	#Fade out of cutscene
	yield($EndCutscenePlayer, "animation_finished")
	ScreenFader.fade_out()
	yield(ScreenFader, "faded_out")
	$EndCutscenePlayer.play("RESET")
	
	#Fade in to main menu
	var main_menu = load("res://scenes/menu/main_menu.tscn").instance()
	add_child(main_menu)
	main_menu.connect("starting", self, "_on_Game_starting")
	ScreenFader.fade_in()
