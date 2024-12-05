extends Node
class_name SoundService

var num_players:int = 8 #Only play 8 sounds at once. May need to go higher.
var bus:String = "master"
var sound_lib:SoundLib
var in_use:Array = [] # Players in_use. Known for the purposes of stopping sounds.
var available:Array  = []  # The available players.
var queue:Array = []  # The queue of sounds to play.


func _ready()->void:
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p := AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", _on_stream_finished.bind(p))
		p.bus = bus
	%Services.register_service(self)
	sound_lib = load("res://engine/common/libs/sound_lib.tres")


func _on_stream_finished(player:AudioStreamPlayer)->void:
	# When finished playing a stream, make the player available again.
	print("I think a sound finished!")
	player.pitch_scale = 1.0
	available.append(player)




func play(sound_id:String, modulation:String = "randpitch_small")->void:
	#modulations: none, randpitch_small, randpitch_med, randpitch_lg
	#TODO: Will probably need to put things into a channel here later.
	queue.append(  {"sound_id":sound_id, "modulation":modulation}  )





func _process(delta:float)->void:
	# Play a queued sound if any players are available.
	if not  (queue.is_empty())  and (not available.is_empty()):
		var sound_command:Dictionary = queue.pop_front()
		var sound_id:String = sound_command.sound_id
		var modulation:String = sound_command.modulation
		if modulation == "none":
			var stream:AudioStream = sound_lib.get(sound_id)
			available[0].stream = stream
			available[0].play()
			in_use.append({"player":available[0], "sound_id":sound_id})
			available.pop_front()
		if modulation == "randpitch_small":
			var stream:AudioStream = sound_lib.get(sound_id)
			var player:AudioStreamPlayer = available[0]
			player.stream = stream
			player.pitch_scale = randf_range(0.9, 1.1)
			available[0].play()
			in_use.append({"player":available[0], "sound_id":sound_id})
			available.pop_front()
