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
		p.connect("finished", _on_stream_finished)
		p.bus = bus
	%Services.register_service(self)
	sound_lib = load("res://engine/common/libs/sound_lib.tres")


func _on_stream_finished(stream:AudioStreamPlayer)->void:
	# When finished playing a stream, make the player available again.
	print("I think a sound finished!")
	available.append(stream)


func play(sound_id:String)->void:
	queue.append(sound_id)


#Crude, but allows things that call into this to ask to stop any instances of their own sound.
#Use sparingly, and only for continuous sounds that will be interrupted.
func stop(sound_id:String)->void:
	AudioStream
	for dict:Dictionary in in_use:
		if dict["sound_id"] == sound_id:
			var player:AudioStreamPlayer = dict["player"]
			player.stop()
			player.finished.emit()



func _process(delta:float)->void:
	# Play a queued sound if any players are available.
	if not  (queue.is_empty())  and (not available.is_empty()):
		var sound_id:String = queue.pop_front()
		var stream:AudioStream = sound_lib.get(sound_id)
		available[0].stream = stream
		available[0].play()
		in_use.append({"player":available[0], "sound_id":sound_id})
		available.pop_front()
